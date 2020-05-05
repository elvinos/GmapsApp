from django.urls import path, re_path
from django.contrib import admin
from django.contrib.auth import logout
from django.views.generic import TemplateView

from django.conf.urls import include

from config.api import api

urlpatterns = [
    path('admin/', admin.site.urls, name='admin'),
    path('logout/', logout, {'next_page': '/'}, name='logout'),
    path('api/', include(api.urls)),
    path('api-auth/', include('rest_framework.urls', namespace='rest_framework')),
    re_path(".*", TemplateView.as_view(template_name="index.html"))
]
