# -*- coding: utf-8 -*-

# Autor: Aurelio Vivas <aa.vivas@uniandes.edu.co>
# Name: collectlogs.py
# This application collect the logs located on remote servers running a Flask API.

# Running this command line tool
# python logcolector

import requests
import servers
import click
import logging


logging.basicConfig(
    format='%(levelname)s : %(asctime)s : %(message)s',
    level=logging.DEBUG
)

# To print loggin information in the console
logging.getLogger().addHandler(logging.StreamHandler())


@click.group()
def collect():
    pass

def get_server_log(ip_address_port,endpoint):
    url = 'http://{}{}'.format(ip_address_port,endpoint)
    response = requests.get(url)
    print(response.text)
    return response.text

def remove_server_log(ip_address_port,endpoint):
    url = 'http://{}{}'.format(ip_address_port,endpoint)
    response = requests.post(url)
    print(response.text)
    return response.text

def collect_servers_logs(servers,endpoint,outfile_suffix='.txt'):
    for server_name, ip_address_port in servers.items():
        text = get_server_log(ip_address_port,endpoint)
        file_path = server_name + outfile_suffix
        with open(file_path,'w') as file:
            file.write(text)

def remove_servers_logs(servers,endpoint):
    for server_name, ip_address_port in servers.items():
        text = remove_server_log(ip_address_port,endpoint)

@collect.command()
def collect_out():
    collect_servers_logs(
        servers=servers.SERVERS,
        endpoint='/log/out',
        outfile_suffix='_out.txt',
    )

@collect.command()
def collect_err():
    collect_servers_logs(
        servers=servers.SERVERS,
        endpoint='/log/err',
        outfile_suffix='_err.txt',
    )

@collect.command()
def remove_out():
    remove_servers_logs(
        servers=servers.SERVERS,
        endpoint='/log/out/clean'
    )

@collect.command()
def remove_err():
    remove_servers_logs(
        servers=servers.SERVERS,
        endpoint='/log/err/clean'
    )

if __name__ == '__main__':
    collect()

    