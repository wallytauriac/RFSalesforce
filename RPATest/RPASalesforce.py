from simple_salesforce import Salesforce

import requests
import json

def get_Oauth_token():

    params = {
        "grant_type": "password",
        # Consumer Key
        "client_id": "3MVG9cHH2bfKACZYn6XBmJXDPNqgaI3XzN4qgiQDwQy5tbG6U0QnzcoaajU4Ba7vFImV_bi0JnShR5u.1u4qC",
        # Consumer Secret
        "client_secret": "1746DCFE2386B0709B75387E3818DB9BB0BB609B2D836921A2BE296B295FA1B2",
        "username": "wallytauriac@gmail.com",  # The email you use to login
        "password": "SummerWT#2021wVdIhfOUTFCTILuhqFGHgi4n"  # Concat your password and your security token
    }
    # Driver Body - Get Token
    r = requests.post("https://login.salesforce.com/services/oauth2/token", params=params)
    # if you connect to a Sandbox, use test.salesforce.com instead
    access_token = r.json().get("access_token")
    instance_url = r.json().get("instance_url")
    print("Access Token:", access_token)
    print("Instance URL", instance_url)
    return access_token

def set_security_data():
    # Consumer Key
    client_id = '3MVG9cHH2bfKACZYn6XBmJXDPNqgaI3XzN4qgiQDwQy5tbG6U0QnzcoaajU4Ba7vFImV_bi0JnShR5u.1u4qC'

    # Consumer Secret
    client_secret = '1746DCFE2386B0709B75387E3818DB9BB0BB609B2D836921A2BE296B295FA1B2'

    # Callback URL
    redirectUri = 'https://soldoutinvestmentsinc-dev-ed.lightning.force.com/callback'

    # Header data
    headers = {"Content-Type": "application/json"}

    # sfdc_user = your SFDC username
    sfdc_user = 'wallytauriac@gmail.com'

    # Security Token for password
    security_token = 'wVdIhfOUTFCTILuhqFGHgi4n'

    # sfdc_pass = your SFDC password
    psw = 'SummerWT#2021'
    sfdc_pass = psw + security_token


def split_key_value_pair(keyval):
    # Input a keyword/value pair separated by ":" and separate into two variables
    ndx = keyval.find(":")
    val = keyval[ndx+1:]
    key = keyval[0:ndx]
    return key, val


def login_to_salesforce(sfdc_user, psw, security_token):
    # Simple Salesforce Login
    sf = Salesforce(username=sfdc_user, password=psw, security_token=security_token)
    return sf

def create_contact(sf, lname, email):
    # sf.sObject.Operator(keyword:value pairs)
    try:
        contact_data = sf.Contact.create({'LastName': lname, 'Email': email})
    except Exception as e:
        print(e)
        return e
    id = contact_data['id']
    if contact_data['success'] == True:
        print(id)
        contact_data2 = sf.Contact.get(id)
        return contact_data2
    else:
        return contact_data2['errors']

def get_id(sf, sobject):
    query = "SELECT Id FROM " + sobject
    data = sf.query(query)
    return data

def get_by_id(sf, sobject, id):
    o = sobject

    try:
        data = getattr(sf, o).get(id)
    except Exception as e:
        print(e)
    return data
