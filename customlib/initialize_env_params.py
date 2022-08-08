def get_variables(environment, appname):
    with open(f"application/{appname}/{environment}/configuration/env.cfg", 'r') as inp:
        envdict = dict(((key.strip(), value.strip()) for key, value in (line.strip().split('=') for line in inp)))
    return envdict
