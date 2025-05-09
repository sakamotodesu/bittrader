package com.sakamotodesu.bittrader;


import com.google.common.io.ByteStreams;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

import static java.nio.charset.StandardCharsets.UTF_8;


public class BitflyerApi {

    public String request() {
        try {
            HttpURLConnection con = createConnection();
            try {
                con = configure(con);
                return receive(con);
            } finally {
                con.disconnect();
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        return null;
    }

    HttpURLConnection createConnection() throws IOException {
        URL url = new URL("https://api.bitflyer.jp/v1/ticker?product_code=BTC_JPY");
        HttpURLConnection con;
        con = (HttpURLConnection) url.openConnection();
        return con;
    }


    HttpURLConnection configure(HttpURLConnection con) throws IOException {

        con.setRequestProperty("Accept", "application/json");
        con.setRequestProperty("Accept-Charset", "UTF-8");
        con.setRequestProperty("User-Agent", "Mozilla/5.0 (Macintosh; U; Intel Mac OS X; ja-JP-mac; rv:1.8.1.6) Gecko/20070725 Firefox/2.0.0.6");
        con.setRequestMethod("GET");
        con.setConnectTimeout(10000);
        con.setReadTimeout(10000);
        con.setUseCaches(true);

        con.connect();

        return con;
    }

    private String receive(HttpURLConnection con) throws IOException {
        int code = con.getResponseCode();
        String message = con.getResponseMessage();

        try (InputStream in = new BufferedInputStream(con.getInputStream())) {
            byte[] bytes = ByteStreams.toByteArray(in);
            String body = new String(bytes, UTF_8);
            System.out.println("code:" + code);
            System.out.println("message:" + message);
            System.out.println(body);

            String token = System.getenv("/bittrader/api/token");
            if (token != null) {
                System.out.println("env:" + token.substring(0, 5));
            } else {
                System.out.println("env: token is null");
            }
            return body;
        } catch (IOException e) {
            throw new IOException(String.format("%s %s", code, message), e);
        }
    }
}
