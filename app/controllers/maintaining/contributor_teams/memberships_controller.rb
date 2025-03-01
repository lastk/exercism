class Maintaining::ContributorTeams::MembershipsController < ApplicationController
  before_action :ensure_admin!
  before_action :use_team
  before_action :use_membership, only: %i[show edit update destroy]
  before_action :use_seniority_options, only: %i[new create edit update]

  def new
    @membership = ContributorTeam::Membership.new
  end

  def create
    if ContributorTeam::Membership::CreateOrUpdate.(membership_params[:user], @team,
      seniority: membership_params[:seniority],
      visible: membership_params[:visible])
      redirect_to maintaining_contributor_team_path(@team)
    else
      render :new
    end
  end

  def edit; end

  def update
    if ContributorTeam::Membership::CreateOrUpdate.(@membership.user, @membership.team,
      seniority: membership_params[:seniority],
      visible: membership_params[:visible])
      redirect_to maintaining_contributor_team_path(@team)
    else
      render :edit
    end
  end

  def destroy
    ContributorTeam::Membership::Destroy.(@membership.user, @membership.team)

    redirect_to maintaining_contributor_team_path(@team)
  end

  private
  def use_team
    @team = ContributorTeam.find(params[:contributor_team_id])
  end

  def use_membership
    @membership = ContributorTeam::Membership.find(params[:id])
  end

  def use_seniority_options
    @seniority_options = %i[junior medior senior].map do |seniority|
      [seniority.to_s.humanize, seniority]
    end
  end

  def membership_params
    sanitized_params = params.require(:contributor_team_membership).permit(:user, :seniority, :visible)
    sanitized_params[:user] = sanitized_params[:user].blank? ? nil : User.find_by(github_username: sanitized_params[:user])
    sanitized_params
  end
end
