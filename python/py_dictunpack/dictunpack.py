import os

def i2c_all_addr():
    bus_and_addrs = { 
                # bus [ {addr, to_fail} ]
                "0" : [{"0x21" : 0}, {"0x36" : 1}, {"0x50" : 0}],
                "2" : [{"0x2c" : 1}, {"0x48" : 0}, {"0x54" : 1}, {"0x70" : 1}],
                "3" : [{"0x18" : 1}, {"0x25" : 1}, {"0x41" : 0}, {"0x44" : 0}, {"0x49" : 0}, {"0x51" : 0}],
            }

    values = []
    for bus in list(bus_and_addrs.keys()):
        print(bus_and_addrs[bus])
        # print(type(bus_and_addrs[bus]))
        for addrs in bus_and_addrs[bus]:
            addr = list(addrs.keys())[0]
            to_fail =  list(addrs.values())[0]
            if to_fail == 1:
                print("")
                continue
            values.append(os.system("i2cdump -y {} {}".format(bus, addr)))
            print("value: {}".format(values[-1]))

    return json.dumps({"status" : "pass", "values" : values})

i2c_all_addr()
