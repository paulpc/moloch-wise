import requests
import logging

logging.basicConfig(level=logging.INFO)

wresp = requests.post('http://localhost:8081/get?ver=2&ips=92.53.90.4')
if wresp.status_code == 200:
    logging.info('[+] successfully connected to wise')
else:
    logging.critical('[-] unable to connect to wise')
    exit(1)
# generating indicator test lists
doms = requests.get('https://zeustracker.abuse.ch/blocklist.php?download=domainblocklist')
zdomlist = []
for dom in doms.text.split("\n"):
    logging.debug(dom)
    if len(zdomlist) > 5:
        break
    if dom and not dom.startswith("#"):
        zdomlist.append(dom)
ziplist = []
doms = requests.get('https://zeustracker.abuse.ch/blocklist.php?download=ipblocklist')
for dom in doms.text.split("\n"):
    logging.debug(dom)
    if len(ziplist) > 5:
        break
    if dom and not dom.startswith("#"):
        ziplist.append(dom)
tests = {'http://localhost:8081/ip/92.53.90.4':True,
         'http://localhost:8081/ip/1.1.2.4':False,
        'http://localhost:8081/domain/kubernetespodcast.com':False}
for ip in ziplist:
    tests[f"http://localhost:8081/ip/{ip}"] = True
for dom in zdomlist:
    tests[f"http://localhost:8081/domain/{dom}"] = True
for test in tests:
    try:
        wres = requests.get(test)
        if wres.status_code == 200:
            wtest = wres.text
            if len(wtest) > 3 and tests[test]:
                logging.info("[+] found indicator when i should")
            elif len(wtest) > 3 and not tests[test]:
                logging.error("[-] found indicator when i should not")
            elif len(wtest) == 3 and not tests[test]:
                logging.info("[+] did not find indicator when i should not")
            elif len(wtest) == 3 and tests[test]:
                logging.error("[-] did not find indicator when i should")
            else:
                logging.critical("[!!!] How the duck did we get here")
        else:
            logging.critical(f"[-] unable to hit wise successfully - got a {wres.status_code}")
            print(wres.request.url, wres.text)
    except:
        logging.critical("[-] Errored out while tryign to to hit wise")
        exit(1)

