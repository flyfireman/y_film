class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  def index
    # @photos = Photo.all
    @photos = Photo.paginate(:page => params[:page],
      :per_page => params[:pre_page] || 5,
      :include => :user,
      # :conditions => "published = true",
      :order=>"created_at DESC")
    tag_cloud
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @photos }
    end
  end
  #tag method
  def tag_cloud
    @tags = Photo.tag_counts
  end

  def tag
    @photos= Photo.find_tagged_with(params[:id])
    @cc = @photos.paginate(:page => params[:page],
      :per_page => params[:pre_page] || 5,
      :include => :user,
      # :conditions => "published = true",
      :order=>"created_at DESC")
  end
  # GET /photos/1
  # GET /photos/1.xml
  def show
    @photo = Photo.find(params[:id])
    @photos = Photo.paginate(:page => params[:page],
      :per_page => params[:pre_page] || 15,
      :include => :user,
      # :conditions => "published = true",
      :order=>"created_at DESC")
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])

    respond_to do |format|
      if @photo.save
        flash[:notice] = 'Photo was successfully created.'
        format.html { redirect_to(@photo) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      message = @photo.delete_image?? "删除图片成功！" : "更新图片成功！"
      flash[:notice] = message
      redirect_to(@photo)
    else
      render :action => "edit"
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy

    respond_to do |format|
      format.html { redirect_to(photos_url) }
      format.xml  { head :ok }
    end
  end
end
