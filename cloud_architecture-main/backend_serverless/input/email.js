const AWS = require('aws-sdk');
AWS.config.update({
    region: 'eu-west-1'
});
const ses = new AWS.SES();

exports.handler = async (event) => {
    console.log(JSON.stringify(event));
    let data  = {};
    
    for (const record of event.Records) {
        data = JSON.parse(Buffer.from(record.kinesis.data, 'base64'));
        console.log(data);
    }
    
    const params = {
        Destination: {
            ToAddresses: ['tamara.delgado@vista.com']
        },
        Message: {
            Subject: {Data: "Order confirmation"},
            Body: {
                Text: {Data: "Your order has been recieved!"}
            }
        },
        Source: 'tamara.delgado@vista.com'
    };
    
    await ses.sendEmail(params).promise().then(response => {
        console.log(response);
    }, err => {
        console.log('error', err);
    });
}