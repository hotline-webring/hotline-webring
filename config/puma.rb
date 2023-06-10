# https://devcenter.heroku.com/articles/deploying-rails-applications-with-the-puma-web-server

# Increasing the number of workers will increase the amount of resting memory
# your dynos use. Increasing the number of threads will increase the amount of
# potential bloat added to your dynos when they are responding to heavy
# requests.
#
# Starting with a low number of workers and threads provides adequate
# performance for most applications, even under load, while maintaining a low
# risk of overusing memory.
workers Integer(ENV.fetch("WEB_CONCURRENCY", 2))
threads_count = Integer(ENV.fetch("MAX_THREADS", 2))
threads(threads_count, threads_count)

preload_app!

rackup DefaultRackup
environment ENV.fetch("RACK_ENV", "development")

# Allow puma to be restarted by `rails restart` command.
plugin :tmp_restart
