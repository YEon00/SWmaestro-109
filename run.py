from flask import Flask
from flask import render_template
from flask_restful import Resource, Api
from flask_bootstrap import Bootstrap
from flask import  request, Response
#from flask_mysqldb import MySQL
import dbAPI
import sys
reload(sys)
sys.setdefaultencoding("UTF-8")
app = Flask(__name__)
api = Api(app)
Bootstrap(app)

class RegistUser(Resource):
    def post(self):
        return{'result':'ok'}

api.add_resource(RegistUser,'/user')

@app.route('/sensor', methods = ['POST'])
def sensor():
    #print(request)
    user_id = request.get_json().get('user_id')
    sensor_id = request.get_json().get('sensor_id')
    num = request.get_json().get('num')
    day = request.get_json().get('day')
    dbAPI.insert_data(str(user_id), str(sensor_id), str(num), str(day))
    return 'sensor'
@app.route('/robot_info/<data>', methods = ['POST'])
def robot_info_post(data):
    if request.method == 'POST': # INSERT
        name = request.get_json().get('name')
        robot_id = request.get_json().get('robot_id')
        user_id = request.get_json().get('user_id')
        dbAPI.insert_robot_info(name, robot_id, user_id)
        return 'robot_info_post'
    else:
        return 'else'

@app.route('/user_info/<data>', methods = ['GET','POST'])
def user_info_post(data):
    if request.method == 'GET': # SELECT    
        prot_id = request.args['prot_id']
        if(data == 'id'):
            user = dbAPI.select_where("user_info",1,'id',prot_id=prot_id)
        elif(data == 'name'):
            user = dbAPI.select_where("user_info",1,"name",prot_id=prot_id)
        elif(data == 'gender'):
            user = dbAPI.select_where("user_info",1,"gender",prot_id=prot_id)
        elif(data == 'birth'):
            user = dbAPI.select_where("user_info",1,"birth",prot_id=prot_id)
        elif(data == 'address'):
            user = dbAPI.select_where("user_info",1,"address",prot_id=prot_id)
        elif(data == 'contact'):
            user = dbAPI.select_where("user_info",1,"contact",prot_id=prot_id)
        #print(user)
        return str(user[0])
    else: # POST (INSERT)
        name = request.get_json().get('name')
        gender = request.get_json().get('gender')
        birth = request.get_json().get('birth')
        address = request.get_json().get('address')
        contact = request.get_json().get('contact')
        prot_id = request.get_json().get('prot_id')
        #print(name, contact, prot_id)
        dbAPI.insert_user_info(name, gender, birth, address, contact, prot_id)
        return "user_info_post"

@app.route('/prot_info/<data>', methods = ['GET','POST'])
def prot_info_post(data):
    if request.method == 'GET': # SELECT
        if(data == 'name'):
            contact = request.args['contact']
            prot = dbAPI.select_where("prot_info",1,"name",contact=contact)
        elif(data == 'contact'):
            name = request.args['name']
            prot = dbAPI.select_where("prot_info",1,"contact",name=name)
        elif(data == 'id'):
            contact = request.args['contact']
            prot = dbAPI.select_where("prot_info",1,"id",contact=contact)
        #print(prot)
        return str(prot[0])
    else: # POST (INSERT)
        name = request.get_json().get('name')
        contact = request.get_json().get('contact')
        #print(dbAPI.select_where("activity",1,"timestamp",id=1))
        #dbAPI.insert_data("activity",70,1)
        #dbAPI.insert_data("fall_down",1)
        dbAPI.insert_prot_info(name, contact)
        return "prot_info_post"


@app.route('/ffff', methods = ['POST'])
def ffff():
    if request.method == 'POST':
        print(request.get_json())
        user_id = request.get_json().get('user_id')
        fall = request.get_json().get('fall')
        dbAPI.ffff_data('ffff',user_id,fall)
        return 'ffff'
    else:
        return 'ffff'

#temperature(1), humidity(2), wake_up(3), sleep(4), fall_down(5), activity(6) 
@app.route('/')
def index():
    graph_fall = dbAPI.select_fall_down()
    count_fall = dbAPI.select_fall_down_count()
    wake_up = dbAPI.select_wake_up()
    sleep = dbAPI.select_sleep()
    temperature = dbAPI.select_where("sensor_data",0,"num",sensor_id = 1, user_id = 1)
    humidity = dbAPI.select_where("sensor_data",0,"num",sensor_id = 2, user_id = 1)
    user_info = dbAPI.select_where("user_info",0,"*",id=1)
    
    return render_template('index.html',row = graph_fall, data = temperature, data1 = user_info, row1 = count_fall, data3 = humidity,sleep = wake_up)

@app.route('/contact')
def index3():
    user_info = dbAPI.select_where("user_info",0,"*",id=1)
    temperature = dbAPI.select_where("sensor_data",0,"num",sensor_id = 1, user_id = 1)
    return render_template('Contacts.html',row = user_info)



if __name__=='__main__':
    app.run(host='0.0.0.0',port=5000, debug=True)


