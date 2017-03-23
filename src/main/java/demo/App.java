package demo;

import java.io.IOException;

import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

public class App {

    public static void main(String[] args) throws Exception {
        System.out.println("Running Demo! Getting IP info...");

        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url("http://ipinfo.io/json")
                .build();

        try {
            Response response = client.newCall(request).execute();
            System.out.println(response.body().string());
        } catch (IOException e) {
            System.err.println("Error getting IP info!");
        }
    }

}
