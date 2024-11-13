from common import utils
from common import variables

if __name__ == '__main__':
    client_name = input('Введите имя: ')

    parser = utils.create_parser()
    namespace = parser.parse_args()

    sock = utils.get_client_socket(namespace.addr, namespace.port)

    serv_addr = sock.getpeername()
    print(f'Connected to server: {serv_addr[0]}:{serv_addr[1]}')

    variables.PRESENCE['user']['account_name'] = client_name
    utils.send_data(sock, variables.PRESENCE)

    while True:
        data = utils.get_data(sock)

        if data['response'] != '200':
            break

        msg = input('Введите сообщение ("exit" для выхода): ')
        variables.MESSAGE['message'] = msg
        utils.send_data(sock, variables.MESSAGE)

    sock.close()
