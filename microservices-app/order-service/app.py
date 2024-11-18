from flask import Flask, jsonify, request

app = Flask(__name__)
orders = []

@app.route('/orders', methods=['GET'])
def get_orders():
    return jsonify(orders), 200

@app.route('/orders', methods=['POST'])
def create_order():
    order = request.json
    orders.append(order)
    return jsonify(order), 201

@app.route('/orders/<int:order_id>', methods=['PUT'])
def update_order(order_id):
    for order in orders:
        if order['id'] == order_id:
            order.update(request.json)
            return jsonify(order), 200
    return jsonify({"error": "Order not found"}), 404

@app.route('/orders/<int:order_id>', methods=['DELETE'])
def delete_order(order_id):
    global orders
    orders = [order for order in orders if order['id'] != order_id]
    return jsonify({"message": "Order deleted"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5002)
