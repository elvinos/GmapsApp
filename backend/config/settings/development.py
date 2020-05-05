from config.settings.base import *

DEBUG = env.bool('DEBUG', default=True)

# SECRET_KEY = env.str('SECRET_KEY')
#
# # EMAIL CONFIGURATION
# # ------------------------------------------------------------------------------
# EMAIL_PORT = env.int('EMAIL_PORT', default='1025')
# EMAIL_HOST = env.str('EMAIL_HOST', default='mailhog')
#
ALLOWED_HOSTS = '*'
# DOMAIN = env.str('DOMAIN')
