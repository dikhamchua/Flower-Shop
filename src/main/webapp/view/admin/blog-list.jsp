<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="icon" type="image/png" href="assets/images/favicon.png" sizes="16x16">

    <title>Blog Management || Clothing</title>
    <jsp:include page="../common/dashboard/css-dashboard.jsp"></jsp:include>
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/css/iziToast.min.css">
    <style>
        .fixed-width-btn {
            min-width: 120px;
            text-align: center;
        }
        .blog-content-preview {
            max-height: 100px;
            overflow: hidden;
            text-overflow: ellipsis;
            display: -webkit-box;
            -webkit-line-clamp: 3;
            -webkit-box-orient: vertical;
        }
    </style>
    
</head>

<body>
    <!-- Sidebar -->
    <jsp:include page="../common/dashboard/sidebar-dashboard.jsp"></jsp:include>

    <!-- Header -->
    <jsp:include page="../common/dashboard/header-dashboard.jsp"></jsp:include>

    <c:url value="/admin/manage-blog" var="paginationUrl">
        <c:param name="action" value="list" />
        <c:if test="${not empty param.status}">
            <c:param name="status" value="${param.status}" />
        </c:if>
        <c:if test="${not empty param.searchTitle}">
            <c:param name="searchTitle" value="${param.searchTitle}" />
        </c:if>
    </c:url>

    <div class="dashboard-main-body">
        <div class="d-flex flex-wrap align-items-center justify-content-between gap-3 mb-24">
            <h6 class="fw-semibold mb-0">Blog Management</h6>
            <ul class="d-flex align-items-center gap-2">
                <li class="fw-medium">
                    <a href="index.html" class="d-flex align-items-center gap-1 hover-text-primary">
                        <iconify-icon icon="solar:home-smile-angle-outline" class="icon text-lg"></iconify-icon>
                        Dashboard
                    </a>
                </li>
                <li>-</li>
                <li class="fw-medium">Blog List</li>
            </ul>
        </div>

        <!-- Filter Section -->
        <div class="card mb-24">
            <div class="card-body p-24">
                <form action="${pageContext.request.contextPath}/admin/manage-blog" method="GET">
                    <div class="row g-3">
                        <div class="col-md-4">
                            <input type="text" class="form-control" name="searchTitle" placeholder="Search by blog title" 
                                   value="${param.searchTitle}">
                        </div>
                        <div class="col-md-3">
                            <select class="form-select" name="status">
                                <option value="">All Status</option>
                                <option value="published" ${param.status == 'published' ? 'selected' : ''}>Published</option>
                                <option value="hidden" ${param.status == 'hidden' ? 'selected' : ''}>Hidden</option>
                                <option value="draft" ${param.status == 'draft' ? 'selected' : ''}>Draft</option>
                            </select>
                        </div>
                        <div class="col-md-2">
                            <button type="submit" class="btn btn-primary w-100">Filter</button>
                        </div>
                        <div class="col-md-3">
                            <a href="${pageContext.request.contextPath}/admin/manage-blog?action=add" class="btn btn-success w-100">
                                Add New Blog
                            </a>
                        </div>
                    </div>
                </form>
            </div>
        </div>

        <!-- Blog Table -->
        <div class="card">
            <div class="card-body p-24">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Title</th>
                                <th>Content</th>
                                <th>Status</th>
                                <th>Created At</th>
                                <th>Updated At</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="blog" items="${blogs}" varStatus="loop">
                                <tr>
                                    <td>${loop.index + 1}</td>
                                    <td>${blog.title}</td>
                                    <td>
                                        <div class="blog-content-preview">
                                            ${blog.content}
                                        </div>
                                    </td>
                                    <td>
                                        <c:choose>
                                            <c:when test="${blog.status == 'published'}">
                                                <span class="badge bg-success">Published</span>
                                            </c:when>
                                            <c:when test="${blog.status == 'hidden'}">
                                                <span class="badge bg-secondary">Hidden</span>
                                            </c:when>
                                            <c:otherwise>
                                                <span class="badge bg-warning">Draft</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
                                    <td>${blog.createdAt}</td>
                                    <td>${blog.updatedAt}</td>
                                    <td>
                                        <div class="d-flex gap-2">
                                            <a href="${pageContext.request.contextPath}/admin/manage-blog?action=edit&id=${blog.id}" 
                                               class="btn btn-sm btn-primary">
                                                <iconify-icon icon="material-symbols:edit"></iconify-icon>
                                            </a>
                                            
                                            <c:choose>
                                                <c:when test="${blog.status != 'published'}">
                                                    <button type="button" 
                                                            class="btn btn-sm btn-success fixed-width-btn"
                                                            onclick="confirmPublish('${blog.id}')">
                                                        <i class="fas fa-check"></i> Publish
                                                    </button>
                                                </c:when>
                                                <c:when test="${blog.status == 'published'}">
                                                    <button type="button" 
                                                            class="btn btn-sm btn-secondary fixed-width-btn"
                                                            onclick="confirmHide('${blog.id}')">
                                                        <i class="fas fa-eye-slash"></i> Hide
                                                    </button>
                                                </c:when>
                                            </c:choose>
                                            
                                            <button type="button" 
                                                    class="btn btn-sm btn-danger fixed-width-btn"
                                                    onclick="confirmDelete('${blog.id}')">
                                                <i class="fas fa-trash-alt"></i> Delete
                                            </button>
                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                            
                            <c:if test="${empty blogs}">
                                <tr>
                                    <td colspan="7" class="text-center">No blogs found</td>
                                </tr>
                            </c:if>
                        </tbody>
                    </table>
                </div>

                <!-- Pagination -->
                <nav class="mt-24">
                    <ul class="pagination justify-content-center">
                        <c:if test="${currentPage > 1}">
                            <li class="page-item">
                                <a class="page-link" href="${paginationUrl}&page=${currentPage - 1}" aria-label="Previous">
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
                                <a class="page-link" href="${paginationUrl}&page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </div>
        </div>
    </div>

    <!-- JS here -->
    <jsp:include page="../common/dashboard/js-dashboard.jsp"></jsp:include>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/izitoast/1.4.0/js/iziToast.min.js"></script>
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            var toastMessage = "${sessionScope.toastMessage}";
            var toastType = "${sessionScope.toastType}";
            if (toastMessage) {
                iziToast.show({
                    title: toastType === 'success' ? 'Success' : 'Error',
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
        
        function confirmPublish(blogId) {
            if (confirm('Are you sure you want to publish this blog?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/manage-blog?action=publish&id=' + blogId;
            }
        }
        
        function confirmHide(blogId) {
            if (confirm('Are you sure you want to hide this blog?')) {
                window.location.href = '${pageContext.request.contextPath}/admin/manage-blog?action=hide&id=' + blogId;
            }
        }
        
        function confirmDelete(blogId) {
            if (confirm('Are you sure you want to delete this blog? This action cannot be undone.')) {
                window.location.href = '${pageContext.request.contextPath}/admin/manage-blog?action=delete&id=' + blogId;
            }
        }
    </script>
</body>
</html> 