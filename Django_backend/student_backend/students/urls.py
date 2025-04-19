from django.urls import path
from . import views

urlpatterns = [
     # Student endpoints
    path('students/', views.student_list, name='student-list'),
    path('students/<int:pk>/', views.student_detail, name='student-detail'),

     # Internship endpoints
    path('internships/', views.internship_list, name='internship-list'),
    path('internships/<int:pk>/', views.internship_detail, name='internship-detail'),
    # path('students/<int:pk>/internships/',views.internship_detail, name='internship-detail' ),
    path('students/<int:student_id>/add-internship/', views.AddInternshipForStudentAPIView.as_view(), name='add-internship'),

    # Project endpoints
    path('projects/', views.project_list, name='project-list'),
    path('projects/<int:pk>/', views.project_detail, name='project-detail'),
    # path('students/<int:pk>/add-project/', views.project_list),
    path('students/<int:student_id>/add-project/', views.AddProjectForStudentAPIView.as_view(), name='add-project'),

    path('opportunities/', views.opportunity_list_create, name='opportunity-list-create'),
    path('opportunities/<int:pk>/', views.opportunity_detail, name='opportunity-detail'),
]
