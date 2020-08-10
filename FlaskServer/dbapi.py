# -*- coding: utf-8 -*

import pymysql

# RDS MYSQL information
host = "db109.cpehjs7hbg19.ap-northeast-2.rds.amazonaws.com"
port = 3306
userName = "admin"
userPasswd = "admin109"
database = "robot1"

# connect RDS
def connectRDS(host, port, userName, userPasswd, database):
    try:
        connection = pymysql.connect(host, user=userName, passwd=userPasswd, db=database, port=port, use_unicode=True, charset='utf8')
        cursor = connection.cursor()
    except: 
        logging.error("connection fail")
        sys.exit(1)
    return connection, cursor

# INSERT
# insert to user_info table
def insert_user_info(name, gender, birth, address, contact):
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into user_info (name, gender, birth, address, contact) values ('"+name+"','"+gender+"','"+birth+"','"+address+"','"+contact+"');"
    cursor.execute(query)
    connection.commit()

# insert to robot_info table
def insert_robot_info(robot_name, robot_id):
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into robot_info (robot_name, robot_id) values ('"+robot_name+"',"+robot_id+");"
    cursor.execute(query)
    connection.commit()

# insert to fall_down table
def insert_fall_down():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into fall_down () values ();"
    cursor.execute(query)
    connection.commit()

# insert to wake_up table
def insert_wake_up():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into wake_up () values ();"
    cursor.execute(query)
    connection.commit()

# insert to sleep table
def insert_sleep():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into sleep () values ();"
    cursor.execute(query)
    connection.commit()

# insert to activity table    
def insert_activity(num):
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into activity (num) values (" + str(num) + ");"
    cursor.execute(query)
    connection.commit()

# insert to body_temp table    
def insert_body_temp(num):
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "insert into body_temp (num) values (" + str(num) + ");"
    cursor.execute(query)
    connection.commit()

# SELECT
# select from falldown table
def select_fall_down():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from fall_down;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()

    return rows

# select from wakeup table



def select_wake_up():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from wake_up;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    result = []
    for row in rows:
        data = []
        data.append(row[0])
        data.append(str(row[1]))
        result.append(data)
    return result

# select from gosleep table
def select_sleep():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from sleep;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    result = []
    for row in rows:
        data = []
        data.append(row[0])
        data.append(str(row[1]))
        result.append(data)
    return result

# select from activity table
def select_activity():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from activity;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    result = []
    for row in rows:
        data = []
        data.append(row[0])
        data.append(row[1])
        data.append(str(row[2]))
        result.append(data)
    return result

def select_activity2():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select TIMESTAMP, NUM from activity;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    return rows

# select from temperature table
def select_body_temp2():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from body_temp;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    result = []
    for row in rows:
        data = []
        data.append(row[0])
        data.append(row[1])
        data.append(str(row[2]))
        result.append(data)
    return result

def select_body_temp():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from body_temp;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    
    return rows


def select_user_info():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from user_info;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    
    return rows

def select_addresstest():
    connection, cursor = connectRDS(host, port, userName, userPasswd, database)
    query = "select * from addresstest;"
    cursor.execute(query)
    connection.commit()
    rows = cursor.fetchall()
    
    return rows