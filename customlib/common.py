import datetime
import random


def get_time_stamp():
    # ct stores current time
    ct = datetime.datetime.now().strftime("%d%b%Y%H%M%S")
    return ct


def get_exec_time_stamp():
    # ct stores current time
    ct = datetime.datetime.now().strftime("%d%b%Y-%H:%M:%S")
    return ct


def get_rand_num():
    numb = random.randint(10, 100)
    return numb


def get_random_num(num1, num2):
    num = random.randint(int(num1), int(num2))
    return num


def get_char_count(c, givenstr):
    counter = str(givenstr).count(c)
    return counter


def get_code(giventext):
    code = giventext.split(' ')[-1]
    return code


def get_vpn_details(giventext):
    codearr = giventext.split('.')
    vpn_name = codearr[0] + "." + codearr[1]
    vpn_pub_name = codearr[0] + codearr[1]
    return [vpn_name, vpn_pub_name]


def get_account_level_code(giventext):
    codearr = giventext.split('.')
    L10 = codearr[0] + "." + codearr[1]
    L20 = codearr[0] + "." + codearr[1] + "." + codearr[2]
    return [L10, L20]
