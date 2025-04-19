from rest_framework.decorators import api_view
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from .models import Student, Internship, Project, Opportunity
from .serializers import StudentSerializer, InternshipSerializer, ProjectSerializer, OpportunitySerializer

@api_view(['GET', 'POST'])
def student_list(request):
    if request.method == 'GET':
        students = Student.objects.all()
        serializer = StudentSerializer(students, many=True)
        return Response(serializer.data)
    
    elif request.method == 'POST':
        serializer = StudentSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def student_detail(request, pk):
    try:
        student = Student.objects.get(pk=pk)
    except Student.DoesNotExist:
        return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = StudentSerializer(student)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = StudentSerializer(student, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        student.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)

# INTERNSHIP VIEWS
@api_view(['GET', 'POST'])
def internship_list(request):
    if request.method == 'GET':
        internships = Internship.objects.all()
        serializer = InternshipSerializer(internships, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = InternshipSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def internship_detail(request, pk):
    try:
        internship = Internship.objects.get(pk=pk)
    except Internship.DoesNotExist:
        return Response({'error': 'Internship not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = InternshipSerializer(internship)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = InternshipSerializer(internship, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        internship.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)


# PROJECT VIEWS
@api_view(['GET', 'POST'])
def project_list(request):
    if request.method == 'GET':
        projects = Project.objects.all()
        serializer = ProjectSerializer(projects, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = ProjectSerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def project_detail(request, pk):
    try:
        project = Project.objects.get(pk=pk)
    except Project.DoesNotExist:
        return Response({'error': 'Project not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = ProjectSerializer(project)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = ProjectSerializer(project, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        project.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)
    
# ADD INTERNSHIP TO STUDENT
class AddInternshipForStudentAPIView(APIView):
    def get(self, request, student_id):
        internships = Internship.objects.filter(student_id=student_id)
        serializer = InternshipSerializer(internships, many=True)
        return Response(serializer.data)
    
    def post(self, request, student_id):
        print("Received data:", request.data)

        try:
            student = Student.objects.get(id=student_id)
        except Student.DoesNotExist:
            return Response({'error': 'Student not found'}, status=404)

        data = request.data.copy()
        data['student'] = student.id

        serializer = InternshipSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=201)
        return Response(serializer.errors, status=400)


# ADD PROJECT TO STUDENT
class AddProjectForStudentAPIView(APIView):
    def get(self, request, student_id):
        projects = Project.objects.filter(student_id=student_id)
        serializer = ProjectSerializer(projects, many=True)
        return Response(serializer.data)

    def post(self, request, student_id):
        try:
            student = Student.objects.get(id=student_id)
        except Student.DoesNotExist:
            return Response({'error': 'Student not found'}, status=status.HTTP_404_NOT_FOUND)

        data = request.data.copy()
        data['student'] = student.id

        serializer = ProjectSerializer(data=data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
@api_view(['GET', 'POST'])
def opportunity_list_create(request):
    if request.method == 'GET':
        opportunities = Opportunity.objects.all()
        serializer = OpportunitySerializer(opportunities, many=True)
        return Response(serializer.data)

    elif request.method == 'POST':
        serializer = OpportunitySerializer(data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

@api_view(['GET', 'PUT', 'DELETE'])
def opportunity_detail(request, pk):
    try:
        opportunity = Opportunity.objects.get(pk=pk)
    except Opportunity.DoesNotExist:
        return Response({'error': 'Opportunity not found'}, status=status.HTTP_404_NOT_FOUND)

    if request.method == 'GET':
        serializer = OpportunitySerializer(opportunity)
        return Response(serializer.data)

    elif request.method == 'PUT':
        serializer = OpportunitySerializer(opportunity, data=request.data)
        if serializer.is_valid():
            serializer.save()
            return Response(serializer.data)
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

    elif request.method == 'DELETE':
        opportunity.delete()
        return Response(status=status.HTTP_204_NO_CONTENT)    