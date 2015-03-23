

describe 'The riemann-http app' do
  include Rack::Test::Methods

  def app
    RiemannHttp
  end

  def sendRequest

    authorize 'admin', 'admin'

    params = {  host: 'web3',
                service: 'api latency',
                state: 'warn',
                metric: 63.5,
                description: "63.5 milliseconds per request",
                time: 1234 }
    post "/", params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }
  end

  it "expects json messages" do
    sendRequest()

    expect(last_response).to be_ok
    expect(last_response.body).to eq('{"host":"web3","service":"api latency","state":"warn","metric":63.5,"description":"63.5 milliseconds per request","time":1234}')

  end

  it "test without authentication" do
    params = {  host: 'web3',
                service: 'api latency',
                state: 'warn',
                metric: 63.5,
                description: "63.5 milliseconds per request",
                time: 1234 }
    post "/", params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(last_response.unauthorized?).to be true

  end

  it "test with bad credentials" do
    authorize 'bad', 'boy'
    params = {  host: 'web3',
                service: 'api latency',
                state: 'warn',
                metric: 63.5,
                description: "63.5 milliseconds per request",
                time: 1234 }
    post "/", params.to_json, { 'CONTENT_TYPE' => 'application/json', 'ACCEPT' => 'application/json' }

    expect(last_response.unauthorized?).to be true

  end

end
