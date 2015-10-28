import sys

def main():
    i=1
    with open('inventory', 'w') as inventory_file:
        inventory = '' 
        for line in sys.stdin:
            i = i + 1
            splitted_line = line.split(': ')
            group = splitted_line[0]
            hosts = splitted_line[1].replace('\n', '').split(',')
            
            inventory = inventory + '\n[%s]\n' % group
            for host in hosts:
                if group == 'mesosphere-masters':
                    i = i + 1
                    inventory = inventory + '%s zookeeper_id=%s\n' % (host, i)
                else:
                    inventory = inventory + '%s\n' % host
            inventory = inventory + '\n'
        inventory_file.write(inventory)
    
main()
