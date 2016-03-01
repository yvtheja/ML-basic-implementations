function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
bigDelta2 = 0;
bigDelta1 = 0;
X = [ones(m,1) X];
for i=1:m
	z2 = Theta1*X(i, :)';
	A = sigmoid(z2);
	
	A = [ones(1, 1); A];

	z3 = Theta2*A;
	A2 = sigmoid(z3);
	temp = zeros(size(A2,1), 1);
	temp(y(i, 1), 1) = 1;
	Y = temp;
	k = 0;
	for j=1:size(A2, 1)
		firstPart = - Y(j, 1) * log(A2(j, 1));
		secondPart = - (1 - Y(j, 1))*log(1 - A2(j, 1));
		result = firstPart + secondPart;
		k = k + result;	
	endfor
	J = J + k;
	smallDelta3 = A2 - Y;
	smallDelta2 = (Theta2)' * smallDelta3 .* sigmoidGradient([ones(1, 1); z2]);
	smallDelta2 = smallDelta2(2:end);
	bigDelta2 = bigDelta2 + ((smallDelta3*A')/m);
	bigDelta1 = bigDelta1 + ((smallDelta2 * X(i, :))/m);
endfor
Theta1_grad = bigDelta1 + ((lambda*[zeros(size(Theta1, 1), 1) Theta1(:, 2:end)])/m);
Theta2_grad = bigDelta2 + ((lambda*[zeros(size(Theta2, 1), 1) Theta2(:, 2:end)])/m);
temp = sum(sum(Theta1(:,2:size(Theta1,2)) .* Theta1(:,2:size(Theta1,2))));
temp = temp + sum(sum(Theta2(:,2:size(Theta2,2)) .* Theta2(:,2:size(Theta2,2))));
temp = (temp * lambda)/(2*m);
J = (J/m) + temp;

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end