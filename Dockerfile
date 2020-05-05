#FROM python:3.7
#FROM node:12-alpine
#FROM nikolaik/python-nodejs:python3.7-nodejs12
#
#WORKDIR /app/backend
#
##RUN apk update
## Install Python dependencies
#COPY ./backend/requirements.txt /app/backend/
#RUN pip install --upgrade pip -r requirements.txt
#
## Install JS dependencies
#WORKDIR /app/frontend
#
#COPY ./frontend/package.json ./frontend/yarn.lock /app/frontend/
#RUN yarn install
#
## Add the rest of the code
#COPY . /app/
#
## Build static files
#RUN yarn build
#
## Have to move all static files other than index.html to root/
## for whitenoise middleware
#WORKDIR /app/frontend/dist
#
#RUN mkdir root && mv *.js *.json root
#
## Collect static files
#RUN mkdir /app/backend/staticfiles
#
#WORKDIR /app
#
#COPY ./backend/scripts/entrypoint.sh .backend/scripts/start.sh .backend/scripts/gunicorn.sh /
#
## SECRET_KEY is only included here to avoid raising an error when generating static files.
## Be sure to add a real SECRET_KEY config variable in Heroku.
#RUN DJANGO_SETTINGS_MODULE=config.settings.production \
#  python3 backend/manage.py collectstatic --noinput
#
#EXPOSE $PORT
#
#CMD python3 backend/manage.py runserver 0.0.0.0:$PORT

FROM node:12-alpine as build-deps
WORKDIR /frontend
COPY ./frontend/package.json ./frontend/yarn.lock ./
RUN yarn
COPY ./frontend /frontend
RUN yarn build

FROM tiangolo/uwsgi-nginx:python3.7

COPY nginx/prod.conf /etc/nginx/nginx.conf

ENV PYTHONFAULTHANDLER=1 \
    PYTHONUNBUFFERED=1 \
    PYTHONHASHSEED=random \
    PIP_NO_CACHE_DIR=off \
    PIP_DISABLE_PIP_VERSION_CHECK=on \
    PIP_DEFAULT_TIMEOUT=100

#COPY . /app
COPY /backend /app/backend
COPY .env /app/.env
WORKDIR /app/backend
#COPY ./backend/requirements.txt /app/backend/
COPY ./backend/scripts/entrypoint.sh ./backend/scripts/gunicorn.sh /
RUN pip install --upgrade pip -r requirements.txt

COPY --from=build-deps /frontend/dist /dist

WORKDIR /dist
RUN mkdir root && mv *.txt *.js *.json root
#RUN mkdir /app/staticfiles

WORKDIR /app


#ARG SECRET_KEY
#ARG DOMAIN
#ARG DOMAIN_PROD
#ARG ALLOWED_HOSTS
#ENV SECRET_KEY=gCZcBZ78sJsCZ5KgbbT3
#
#ENV DOMAIN=http://localhost:8000
#ENV DOMAIN_PROD=http://localhost:8000
#ENV ALLOWED_HOSTS=*
### Be sure to add a real SECRET_KEY config variable in Heroku.
#RUN DJANGO_SETTINGS_MODULE=config.settings.production \
#    python backend/manage.py collectstatic --noinput

EXPOSE 8000

#CMD python backend/manage.py runserver 0.0.0.0:PORT
CMD ["nginx", "-g", "daemon off;"]
