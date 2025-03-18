<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Access Denied</title>
        <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/bootstrap.min.css">
        <style>
            body {
                height: 100vh;
                display: flex;
                align-items: center;
                justify-content: center;
                background-color: #f8f9fa;
            }
            .error-container {
                text-align: center;
                padding: 40px;
                background: white;
                border-radius: 10px;
                box-shadow: 0 0 10px rgba(0,0,0,0.1);
            }
            .error-code {
                font-size: 72px;
                font-weight: bold;
                color: #dc3545;
                margin-bottom: 20px;
            }
            .error-message {
                font-size: 24px;
                color: #343a40;
                margin-bottom: 30px;
            }
            .back-home {
                text-decoration: none;
                background-color: #007bff;
                color: white;
                padding: 10px 20px;
                border-radius: 5px;
                transition: background-color 0.3s;
            }
            .back-home:hover {
                background-color: #0056b3;
                color: white;
            }
        </style>
    </head>
    <body>
        <div class="error-container">
            <div class="error-code">403</div>
            <div class="error-message">Access Denied</div>
            <p class="mb-4">Sorry, you don't have permission to access this page.</p>
            <a href="${pageContext.request.contextPath}/home" class="back-home">Back to Home</a>
        </div>

        <script src="${pageContext.request.contextPath}/assets/js/bootstrap.bundle.min.js"></script>
    </body>
</html> 