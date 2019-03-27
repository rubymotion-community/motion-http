private java.util.Map<java.lang.String,java.lang.String> mHeaders;
private byte[] mBody;

public void setBody(java.lang.String java_string) {
  mBody = java_string.getBytes(java.nio.charset.Charset.forName("UTF-8"));
}

public byte[] getBody() throws com.android.volley.AuthFailureError {
  return mBody;
}

// Copied from https://github.com/infinitered/bluepotion/blob/68dffa9a91e2e72843f9e07497075645d6bab8e5/lib/project/volley_wrap/request.java#L28
public void setHeaders(java.util.Map<com.rubymotion.String, com.rubymotion.String> map) {
  java.util.HashMap<java.lang.String,java.lang.String> newMap = new java.util.HashMap<java.lang.String, java.lang.String>();
  for (java.util.Map.Entry<com.rubymotion.String,com.rubymotion.String> entry : map.entrySet()) {
    java.lang.Object value = entry.getValue();
    if (value != null) {
      newMap.put(entry.getKey().toString(), value.toString());
    }
  }
  mHeaders = newMap;
}

public java.util.Map<java.lang.String,java.lang.String> getHeaders() throws com.android.volley.AuthFailureError {
  return mHeaders;
}

// Copied from https://github.com/google/volley/blob/95a6796c40f570a723a73d9360dddbd0994ed1d4/src/main/java/com/android/volley/toolbox/StringRequest.java#L88
public java.lang.String parse_body_from_response(com.android.volley.NetworkResponse response) {
  java.lang.String parsed;
  try {
    parsed = new java.lang.String(response.data, com.android.volley.toolbox.HttpHeaderParser.parseCharset(response.headers));
  } catch (java.io.UnsupportedEncodingException e) {
    // Since minSdkVersion = 8, we can't call
    // new String(response.data, Charset.defaultCharset())
    // So suppress the warning instead.
    parsed = new java.lang.String(response.data);
  }
  return parsed;
}

