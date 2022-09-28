
import ballerina/http;

map<Student> StudentStorage = {};

public type Student record {|
    string Id;
    string Name;
    string surname;
    string emailAddress;
    Course [] Allcourses;
|};

public type Course record {|
    string Coursecode;
    int weight;
    int awardedMarks;
|};


service http:Service /api/student on new http:Listener(5500) {

    resource function post addStudent(@http:Payload Student data) returns http:Response {
        //  Create a new student;
        http:Response response = new;
        if (data.Id == "") {
            response.setTextPayload("Error : Please provide the json payload with `id`,`name` and `surname`");
            response.statusCode = 400;
        }
        else {
            StudentStorage[data.Id] = data;
            string payload = "Student added successfully : Student ID = " + data.Id;
            response.setTextPayload(payload);
        }
        return response;
    }

    // Update student details;
    resource function put modifyStudent(@http:Payload Student data) returns http:Response {

        http:Response response = new;
        if (data.Id == "" || !StudentStorage.hasKey(data.Id)) {
            response.setTextPayload("Error : Please provide the json payload with valid `id``");
            response.statusCode = 400;
        }
        else
        {
            StudentStorage[data.Id] = data;
            string payload = data.toBalString();
            response.setTextPayload(payload);
        }
        return response;
    }

    // Update student’s course details;
    resource function put modifyStudentCourse(@http:Payload Student data) returns http:Response {
        http:Response response = new;
        if (data.Id == "" || !StudentStorage.hasKey(data.Id)) {
            response.setTextPayload("Error : Please provide the json payload with valid `id``");
            response.statusCode = 400;
        }
        else
        {
            StudentStorage[data.Id] = data;
            string payload = data.Allcourses.toBalString();
            response.setTextPayload(payload);
        }
        return response;
    }

    // lookup a single student;
    resource function get retriveStudentById(http:Request req, string Id) returns http:Response {
        http:Response response = new;
        if (!StudentStorage.hasKey(Id)) {
            response.setTextPayload("Error : Invalid Student ID");
            response.statusCode = 400;
        }
        else {
            var payload = StudentStorage[Id];
            if (payload is json) {
                response.setJsonPayload(payload);
            }
        }
        return response;
    }

    // fetch all students;
    resource function get retrieveAllStudents() returns http:Response {
        http:Response response = new;
        var payload = StudentStorage;
        if (payload is json) {
            response.setJsonPayload(payload.toBalString());
        }
        return response;
    }

    // delete a student.
    resource function get removeStudentById(http:Request req, string Id) returns http:Response {

        http:Response response = new;
        if (!StudentStorage.hasKey(Id)) {
            response.setTextPayload("Error : Invalid Student ID");
            response.statusCode = 400;
        }
        else {
            _ = StudentStorage.remove(Id);
            string payload = "Deleted student data successfully : student ID = " + Id;
            response.setTextPayload(payload);
        }
        return response;
    }
}

