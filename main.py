#!/usr/bin/env python
# sample script used to convert csv data to sqlite for Liveability app
# Peter Marks & Catherine Marks

INPUT_FILE_NAME = "/Users/marksp/Desktop/Postcode to LGA.csv"
DB_FILE_NAME = "/Users/marksp/Desktop/postcodeToLga.sqlite"

import sqlite3
import os
import csv

def main():
    print("started")
    if os.path.exists(DB_FILE_NAME):
        os.remove(DB_FILE_NAME)
    conn = sqlite3.connect(DB_FILE_NAME)
    c = conn.cursor()
    create_db(c)

    with open(INPUT_FILE_NAME, 'rb') as csvfile:
        rows = csv.reader(csvfile)
        for row in rows:
            write_db(c, row)

    conn.commit()
    conn.close()


def create_db(cursor):
    print("creating db")
    cursor.execute('''CREATE TABLE p2l ('postcode' text, 'lga' text, 'lganame' text)''')


def write_db(cursor, values):
    print(tuple(values))
    cursor.execute('''INSERT INTO p2l VALUES (?,?,?)''', tuple(values))

if __name__ == '__main__':
    main()
