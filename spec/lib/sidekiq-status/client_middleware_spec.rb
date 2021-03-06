require 'spec_helper'

describe Sidekiq::Status::ClientMiddleware do

  let!(:redis) { Sidekiq.redis { |conn| conn } }
  let!(:job_id) { SecureRandom.hex(12) }

  # Clean Redis before each test
  before :each do
    redis.flushall
  end

  describe '#call' do
    it 'sets queued status' do
      allow(SecureRandom).to receive(:hex).once.and_return(job_id)
      expect(StubJob.perform_async(arg1: 'val1')).to eq(job_id)
      expect(redis.hget(job_id, :status)).to eq('queued')
      expect(Sidekiq::Status.queued?(job_id)).to be_truthy
    end

    it 'sets status hash ttl' do
      allow(SecureRandom).to receive(:hex).once.and_return(job_id)
      expect(StubJob.perform_async(arg1: 'val1')).to eq(job_id)
      expect(1..Sidekiq::Status::DEFAULT_EXPIRY).to cover redis.ttl(job_id)
    end

    context 'when redis_pool passed' do
      it 'uses redis_pool' do
        redis_pool = double(:redis_pool)
        allow(redis_pool).to receive(:with)
        expect(Sidekiq).to_not receive(:redis)
        Sidekiq::Status::ClientMiddleware.new.call(StubJob, { 'jid' => SecureRandom.hex }, :queued, redis_pool) do end
      end
    end

    context 'when redis_pool is not passed' do
      it 'uses Sidekiq.redis' do
        allow(Sidekiq).to receive(:redis)
        Sidekiq::Status::ClientMiddleware.new.call(StubJob, { 'jid' => SecureRandom.hex }, :queued) {}
      end
    end
  end
end
