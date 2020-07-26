package com.sakamotodesu.bittrader;

import org.junit.Test;

import static org.hamcrest.Matchers.is;
import static org.junit.Assert.*;

public class SimpleSystemsManagementParasTest {

    @Test
    public void getToken() {
        SimpleSystemsManagementParas ssm = new SimpleSystemsManagementParas();
        assertThat(ssm.getToken("encryption_name"),is("encryption value"));
    }
}