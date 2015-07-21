part of easydr;

class EDDI {
  Map<String,Map<String, Object>> content = {};

  bool add(String bucket, String key, value) {
    if(!content.containsKey(bucket)) {
      content[bucket] = {};
    }
    content[bucket][key] = value;
    return true;
  }

  bool remove(String bucket, String key) {
    if(!content.containsKey(buckket)) {
      throw 'Bucket ' + bucket.toString() + ' does not exist';
    }
    content[bucket].remove(key);
    return true;
  }

  bool createBucket(String bucket) {
    if(!content.containsKey(bucket)) {
      content[bucket] = {};
    }
  }

  Map<String, Map<String, Object>> getBucket(String name) {
    return content[name];
  }

}