def input_default(inp, default, use_defaults=False):
    if use_defaults:
        print('%s [%s]: %s' % (inp, default, default))
        return default
    else:
        return input('%s [%s]: ' % (inp, default)) or default
