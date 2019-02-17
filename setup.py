import subprocess
import json
import os
import getopt
import sys

def main(argv):
    cloaked = False
    password = 'topcoder'

    try:
        opts, args = getopt.getopt(argv, "p:c")
        for opt, value in opts:
            if opt == '-p':
                password = value
            if opt == '-c':
                cloaked = True
    except getopt.GetoptError:
        print '-p password -c[cloaked]'
        sys.exit(1)

    SS_CONFIG_FILE_PAHT = '/etc/shadowsocks-libev/config.json'    

    # generate ss config
    ssConfig = json.loads('{}')
    ssConfig["server"] = "0.0.0.0"
    ssConfig["server_port"] = 80
    ssConfig["local_port"] = 1080
    ssConfig["password"] = password
    ssConfig["timeout"] = 10
    ssConfig["method"] = "aes-256-gcm"

    if (cloaked):
        CLOAK_CONFIG_FILT_PATH = '/etc/Cloak/config/ckserver.json'

        # generate cloak keys
        keyPair = subprocess.check_output(['/etc/Cloak/build/ck-server', '-k']).split(',')
        print 'Generated key pair: public = ' + keyPair[0] + ', private = ' + keyPair[1]
        adminUID = subprocess.check_output(['/etc/Cloak/build/ck-server', '-u'])
        print 'Admin UID: ' + adminUID

        # configure cloak with keys generated
        with open(CLOAK_CONFIG_FILT_PATH, 'r') as f:
            ckConfig = json.load(f)
            ckConfig["PrivateKey"] = keyPair[1]
            ckConfig["AdminUID"] = adminUID
        os.remove(CLOAK_CONFIG_FILT_PATH)
        with open(CLOAK_CONFIG_FILT_PATH, 'w') as f:
            json.dump(ckConfig, f, indent=4)

        # configure ss to use cloak as plugin
        ssConfig["server_port"] = 443
        ssConfig["plugin"] = "/etc/Cloak/build/ck-server"
        ssConfig["plugin_opts"] = CLOAK_CONFIG_FILT_PATH

    # dump ss config file
    if os.path.exists(SS_CONFIG_FILE_PAHT):
        os.remove(SS_CONFIG_FILE_PAHT)
    if not os.path.exists(os.path.dirname(SS_CONFIG_FILE_PAHT)):
        os.makedirs(os.path.dirname(SS_CONFIG_FILE_PAHT))
    with open(SS_CONFIG_FILE_PAHT, 'w') as f:
        json.dump(ssConfig, f, indent=4)

if __name__ == "__main__":
    main(sys.argv[1:])
