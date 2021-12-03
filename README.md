# openseagallery
A simple gallery utilizing A-Frame for viewing OpenSea NFTs

## Initial POC usage

Assumes any path other than root (`host:port/`) is an owner address. Example usage:

```
$ bundle install && bundle exec rackup config.ru
# Visit localhost:9292/<owner_address>
```
