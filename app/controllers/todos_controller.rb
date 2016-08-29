class TodosController < ApplicationController
  @@databaseUrl = 'http://127.0.0.1:5984/exam' # De URL staat nu hier aangezien er een error kwam als deze in application.rb stond

  def index
    # CouchDB way
    #@db = CouchRest.database(@@databaseUrl)
    #@result = @db.view('views/get_todo_by_priority?key=' + params[:priority])['rows']
    #render json: @result

    # Active Record way
    render json: Todo.where(priority: params[:priority])
  end

  def new
    @db = CouchRest.database(@@databaseUrl)

    @todo = Todo.new
    @todo.startDate = todo_params[:start]
    @todo.endDate = todo_params[:end]
    @todo.priority = todo_params[:priority]
    @todo.description = todo_params[:description]
    @todo.status = todo_params[:status]

    if @todo.save
      @response = @db.save_doc({
        id: @todo.id,
        startDate: @todo.startDate,
        endDate: @todo.endDate,
        priority: @todo.priority,
        description: @todo.description,
        status: @todo.status,
        type: 'todo'
      })

      if @response['ok'] === true
        render json: @db.view('views/get_todo_by_id?key=' + @todo.id.to_s)['rows'][0]['value']
      else
        self.error
      end
    else
      self.error
    end
  end

  private
  def todo_params
    params.permit(:start, :end, :priority, :description, :status)
  end

  def error
    render plain: "Woops something went wrong, make sure you did everything right."
  end
end
