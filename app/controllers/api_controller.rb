class ApiController < ApplicationController
  before_action :set_api, only: [:sync, :edit, :update, :destroy]
  before_filter :authenticate_user!

  # GET /api
  # GET /api.json
  def index
    @api = current_user.api.all
  end

  # GET /api/new
  def new
    @api = Api.new
  end

  # GET /api/1/edit
  def edit
  end

  def sync
    @results = @api.sync

    respond_to do |format|
      format.html { redirect_to trades_path, notice: "Successfully synchronized." }
      format.js {
        if @results and @results != "APIKEY_INVALID"
          @count = 0
          if success = @results.select { |e| e[:status] == :success }
            @coins = success.collect { |e| e[:coin_name] }
            @count = success.inject(0){|a,b| a + b[:message]}
          end
          @errors = @results.select { |e| e[:status] == :error }.collect { |e| e[:message] }
        end
      }
    end
  end

  # POST /api
  # POST /api.json
  def create
    @api = current_user.api.new(api_params)

    respond_to do |format|
      if @api.save
        format.html { redirect_to api_index_url, notice: 'Api was successfully created.' }
        format.json { render :show, status: :created, location: api_index_url }
      else
        format.html { render :new }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /api/1
  # PATCH/PUT /api/1.json
  def update
    respond_to do |format|
      if @api.update(api_params)
        format.html { redirect_to api_index_url, notice: 'Api was successfully updated.' }
        format.json { render :show, status: :ok, location: api_index_url }
      else
        format.html { render :edit }
        format.json { render json: @api.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /api/1
  # DELETE /api/1.json
  def destroy
    @api.destroy
    respond_to do |format|
      format.html { redirect_to api_index_url, notice: 'Api was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_api
      @api = Api.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def api_params
      params.require(:api).permit(:exchange_id, :name, :key, :secret)
    end
end
