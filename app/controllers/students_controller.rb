class StudentsController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :render_record_not_found_response
    rescue_from ActiveRecord::RecordInvalid, with: :render_invalid_record

    def index
        if params[:instructor_id]
            instructor = Instructor.find(params[:instructor_id])
            students = instructor.students
        else
            students = Student.all
        end
        render json: students, status: :ok
    end

    def show
        student = find_student
        render json: student, status: :ok        
    end

    def create
        student = Student.create(student_params)
        render json: student, status: :created
    end

    def update
        student = find_student
        student.update!(student_params)
        render json: student, status: :ok
    end

    def destroy
        student = find_student
        student.destroy
        head :no_content
    end

    private

    def find_student
        Student.find(params[:id])
    end

    def student_params
        params.permit(:name, :age, :degree)
    end

    def render_invalid_record(invalid)
        render json: {errors: invalid.record.errors.full_messages}, status: :unprocessable_entity
    end

    def render_record_not_found_response
        render json: { error: "Student not found" }, status: :not_found
    end
end
