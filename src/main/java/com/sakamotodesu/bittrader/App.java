package com.sakamotodesu.bittrader;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@SpringBootApplication
public class App {

    public static void main(String[] args) {
        SpringApplication.run(App.class, args);
    }

    @GetMapping("/")
    String home() {
        BitflyerApi bitflyerApi = new BitflyerApi();
        return bitflyerApi.request();
    }

    public String getGreeting() {
        return "Hello world.";
    }

}
