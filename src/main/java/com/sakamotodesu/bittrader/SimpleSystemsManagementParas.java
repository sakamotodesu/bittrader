package com.sakamotodesu.bittrader;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.simplesystemsmanagement.AWSSimpleSystemsManagement;
import com.amazonaws.services.simplesystemsmanagement.AWSSimpleSystemsManagementClientBuilder;
import com.amazonaws.services.simplesystemsmanagement.model.GetParameterRequest;

public class SimpleSystemsManagementParas {

    private final AWSSimpleSystemsManagement ssm = AWSSimpleSystemsManagementClientBuilder.standard().withRegion(Regions.AP_NORTHEAST_1).build();

    public String getToken(String name) {
        GetParameterRequest getParameterRequest = new GetParameterRequest();
        getParameterRequest.setWithDecryption(true);
        getParameterRequest.setName(name);
        return ssm.getParameter(getParameterRequest).getParameter().getValue();
    }
}