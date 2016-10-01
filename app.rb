require 'sinatra/base'
require 'sucker_punch'
require 'cocaine'

class RunnerJob
  include SuckerPunch::Job

  def perform(branch)
    return false if branch.to_s == ''
    command.run(branch: branch)
  end

  private
  def command
    r10k_bin = App.settings.r10k_bin
    Cocaine::CommandLine.new(r10k_bin, 'deploy environment -p :branch')
  end
end

class App < Sinatra::Base
  configure do
    enable :logging

    set :r10k_bin, ENV.fetch('R10K_BIN', 'r10k')
    set :secret,   ENV.fetch('WEBHOOK_SECRET')
  end

  post '/' do
    valid_secret? || log_and_halt(401, :warn, 'Invalid secret')

    begin
      RunnerJob.perform_async git_branch
      log_and_halt(200, :info, "Deployment started for branch \"#{git_branch}\"")
    rescue KeyError
      log_and_halt(400, :warn, 'Request missing `ref` param')
    end
  end

  get '/ping' do
    body "pong\n"
    halt 200
  end

  private
  def valid_secret?
    env.fetch('HTTP_X_GITLAB_TOKEN', false) == settings.secret
  end

  def git_branch
    params.fetch('ref')[%r{[^/]*\z}, 0]
  end

  def log_and_halt(status, log_level, message)
    logger.send(log_level, message)
    halt(status)
  end
end
