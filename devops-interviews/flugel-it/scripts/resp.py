import httplib2
import sys

def resp(url):
    try:
        http = httplib2.Http()
        resp = http.request(url, 'HEAD')

        if resp[0].status >= 400:
            print("Status code is: " + str(resp[0].status))
            print("Got server response, but you might experiencing some problem with your application.")
            sys.exit(1)

        elif resp[0].status == 200:
            print("Status code is: " + str(resp[0].status))
            print("Application is running.")
            sys.exit(0)

    except httplib2.ServerNotFoundError:
        print("Unable to find server.")
        sys.exit(1)

userInput = sys.argv[1]
print(resp(userInput))
