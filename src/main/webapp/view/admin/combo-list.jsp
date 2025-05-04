<%@page contentType="text/html" pageEncoding="UTF-8" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">

    <title>Manage Combos | Admin</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    <style>
        .fixed-width-btn {
            min-width: 120px;
            text-align: center;
        }
        .product-image {
            width: 100px;
            height: 100px;
            object-fit: cover;
            border-radius: 4px;
            overflow: hidden;
        }
        .product-image-container {
            width: 100px;
            height: 100px;
            overflow: hidden;
            position: relative;
        }
    </style>
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <c:url value="/admin/manage-combo" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty searchFilter}">
            <c:param name="search" value="${searchFilter}" />
        </c:if>
        <c:if test="${not empty statusFilter}">
            <c:param name="status" value="${statusFilter}" />
        </c:if>
    </c:url>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Manage Combos</h6>
        </div>

        <!-- Filter Section -->
        <div class="card mb-24">
            <div class="card-body p-24">
                <form action="${pageContext.request.contextPath}/admin/manage-combo" method="GET">
                    <input type="hidden" name="action" value="list">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="search" placeholder="Search by name..." 
                                   value="${searchFilter}">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="" ${statusFilter == null || statusFilter == '' ? 'selected' : ''}>All statuses</option>
                                <option value="active" ${statusFilter == 'active' ? 'selected' : ''}>Active</option>
                                <option value="inactive" ${statusFilter == 'inactive' ? 'selected' : ''}>Inactive</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="fas fa-search"></i> Search
                            </button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/manage-combo?action=add" class="btn btn-success w-100">
                                <i class="fas fa-plus"></i> Create New Combo
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Combo Table -->
        <div class="card">
            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>No</th>
                                <th>Image</th>
                                <th>Combo Name</th>
                                <th>Description</th>
                                <th>Original Price</th>
                                <th>Discounted Price</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${combos}" var="combo" varStatus="loop">
                                <tr>
                                   <td>${(currentPage - 1) * pageSize + loop.index + 1}</td>
                                    <td>
                                        <div class="product-image-container">
                                            <c:choose>
                                                <c:when test="${not empty combo.image}">
                                                    <img src="${pageContext.request.contextPath}/${combo.image}" alt="${combo.name}" class="product-image">
                                                </c:when>
                                                <c:otherwise>
                                                    <img src="${pageContext.request.contextPath}/assets/images/placeholder.jpg" alt="No Image" class="product-image">
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                    <td>${combo.name}</td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${empty combo.description}">
                                                <span class="text-muted">No description</span>
                                            </c:when>
                                            <c:otherwise>
                                                ${combo.description}
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${combo.originalPrice}</td>
                                    <td>${combo.discountPrice}</td>
                                    <td>
                                        <span class="badge ${combo.status eq 'active' ? 'bg-success' : 'bg-danger'}">
                                            ${combo.status eq 'active' ? 'Active' : 'Inactive'}
                                        </span>
                                    </td>
                                    <td>
                                       ${combo.createdAt}
                                    </td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/manage-combo?action=edit&id=${combo.comboId}" 
                                               class="btn btn-sm btn-primary">
                                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                            </a>
                                            
                                            <c:choose>
                                                <c:when test="${combo.status eq 'active'}">
                                                    <button type="button" 
                                                            class="btn btn-sm btn-danger fixed-width-btn"
                                                            onclick="confirmDeactivate('${combo.comboId}', '${currentPage}')">
                                                        <i class="fas fa-ban"></i> Deactive
                                                    </button>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" 
                                                            class="btn btn-sm btn-success fixed-width-btn"
                                                            onclick="confirmActivate('${combo.comboId}', '${currentPage}')">
                                                        <i class="fas fa-check"></i> Active
                                                    </button>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty combos}">
                                <tr>
                                    <td colspan="9" class="text-center">Không có combo nào được tìm thấy</td> <!-- Update colspan to 9 -->
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <c:if test="${totalPages > 1}">
                    <nav class="mt-24">
                        <ul class="pagination justify-content-center">
                            <c:if test="${currentPage > 1}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Trước">
                                        <span aria-hidden="true">&laquo;</span>
                                    </a>
                                </li>
                            </c:if>

                            <c:forEach begin="1" end="${totalPages}" var="i">
                                <li class="page-item ${currentPage == i ? 'active' : ''}">
                                    <a class="page-link" href="${paginationUrl}&page=${i}">${i}</a>
                                </li>
                            </c:forEach>

                            <c:if test="${currentPage < totalPages}">
                                <li class="page-item">
                                    <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Tiếp">
                                        <span aria-hidden="true">&raquo;</span>
                                    </a>
                                </li>
                            </c:if>
                        </ul>
                    </nav>
                </c:if>
            </div>
        </div>
    </div>

    <main>

    </main>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Thành công' : 'Lỗi',
                    message: toastMessage,
                    position: 'topRight',
                    color: toastType === 'success' ? 'green' : 'red',
                    timeout: 5000,
                    onClosing: function() {
                        fetch('${pageContext.request.contextPath}/remove-toast', {
                            method: 'POST',
                            headers: {
                                'Content-Type': 'application/x-www-form-urlencoded',
                            },
                        }).then(response => {
                            if (!response.ok) {
                                console.error('Failed to remove toast attributes');
                            }
                        }).catch(error => {
                            console.error('Error:', error);
                        });
                    }
                });
            }
        });
    </script>
</body>
</html>

<script>
function confirmDeactivate(comboId, currentPage) {
    if (confirm('Bạn có chắc muốn ngừng hoạt động combo này?')) {
        window.location.href = '${pageContext.request.contextPath}/admin/manage-combo?action=deactivate&id=' + comboId + '&page=' + currentPage;
    }
}

function confirmActivate(comboId, currentPage) {
    if (confirm('Bạn có chắc muốn kích hoạt combo này?')) {
        window.location.href = '${pageContext.request.contextPath}/admin/manage-combo?action=activate&id=' + comboId + '&page=' + currentPage;
    }
}
</script>