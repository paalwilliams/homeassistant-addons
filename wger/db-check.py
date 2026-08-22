#!/usr/bin/env python3
"""Check that wger can actually use its database, before django is involved.

Two failure modes are worth catching here, because neither is legible in the
add-on log otherwise:

* wger's bootstrap reports a refused connection, a wrong password and a missing
  database all as "Database does not exist, creating one now", and then hangs
  in migrate.
* migration core.0023 creates the powersync publication, which needs superuser
  no matter who owns the database, and fails a hundred lines into a traceback.
"""

# Standard Library
import os
import sys

# Third Party
import psycopg


REQUIRED_EXTENSIONS = ('pg_trgm', 'btree_gin')

try:
    connection = psycopg.connect(
        host=os.environ['DJANGO_DB_HOST'],
        port=int(os.environ.get('DJANGO_DB_PORT') or 5432),
        dbname=os.environ['DJANGO_DB_DATABASE'],
        user=os.environ['DJANGO_DB_USER'],
        password=os.environ.get('DJANGO_DB_PASSWORD', ''),
        connect_timeout=10,
    )
except Exception as error:
    print(f'ERROR: cannot open the database: {str(error).strip()}')
    print('ERROR: "does not exist" -> create it, owned by the wger role')
    print('ERROR: "password authentication failed" -> DJANGO_DB_PASSWORD is wrong')
    print('ERROR: "no pg_hba.conf entry" -> the server rejects connections from here')
    sys.exit(1)

with connection, connection.cursor() as cursor:
    cursor.execute('SELECT rolsuper FROM pg_roles WHERE rolname = current_user')
    row = cursor.fetchone()
    is_superuser = bool(row and row[0])

    cursor.execute("SELECT 1 FROM pg_publication WHERE pubname = 'powersync'")
    has_publication = cursor.fetchone() is not None

    cursor.execute('SELECT extname FROM pg_extension')
    installed_extensions = {name for (name,) in cursor.fetchall()}

missing_extensions = [name for name in REQUIRED_EXTENSIONS if name not in installed_extensions]
if missing_extensions and not is_superuser:
    # These are trusted extensions on postgres 13+, so the owner of the database
    # can create them and the migration will do exactly that. Only worth a note
    print(f'Note: {", ".join(missing_extensions)} not installed yet, the migrations')
    print('Note: will try to create them. That needs postgres 13 or newer.')

# There is no equivalent escape hatch for the publication: "FOR ALL TABLES"
# is superuser-only, so a migration run as the database owner cannot create it
if not has_publication and not is_superuser:
    print('ERROR: the powersync publication does not exist, and the wger role is not')
    print('ERROR: a superuser, so migration core.0023 cannot create it.')
    print('ERROR: connect to this database as a superuser and run:')
    print('ERROR:     CREATE PUBLICATION powersync FOR ALL TABLES;')
    sys.exit(1)

print('Database looks usable')
