from flask import Flask, jsonify, request

app = Flask(__name__)
products = []

@app.route('/products', methods=['GET'])
def get_products():
    return jsonify(products), 200

@app.route('/products', methods=['POST'])
def create_product():
    product = request.json
    products.append(product)
    return jsonify(product), 201

@app.route('/products/<int:product_id>', methods=['PUT'])
def update_product(product_id):
    for product in products:
        if product['id'] == product_id:
            product.update(request.json)
            return jsonify(product), 200
    return jsonify({"error": "Product not found"}), 404

@app.route('/products/<int:product_id>', methods=['DELETE'])
def delete_product(product_id):
    global products
    products = [product for product in products if product['id'] != product_id]
    return jsonify({"message": "Product deleted"}), 200

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
