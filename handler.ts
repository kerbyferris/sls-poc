import { DynamoDB, AWSError } from "aws-sdk";
import { APIGatewayProxyHandler } from "aws-lambda";
import uuid4 from "uuid/v4";
import "source-map-support/register";

const docClient = new DynamoDB.DocumentClient();

export const hello: APIGatewayProxyHandler = async (_event, _context) => {
  const id = uuid4();
  const somethingElse = uuid4();
  const record = { id, somethingElse };

  await docClient
    .put({
      TableName: process.env.DYNAMODB_TABLE,
      Item: record
    })
    .promise()
    .then(() => record, (err: AWSError) => Promise.reject(err));

  console.log(record);

  return {
    statusCode: 200,
    body: JSON.stringify({ record }, null, 2)
  };
};
