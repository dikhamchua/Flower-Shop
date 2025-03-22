<%@page contentType="text/html" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!--Product Category Widget Start-->

        <!-- <div class="shop-sidebar">
            <h4>Product Categories</h4>
            <div class="categori-checkbox">
                <form action="#">
                    <ul>
                        <li><input name="product-categori" type="checkbox"><a href="#">Accessories</a><span class="count">(14)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Clothings</a><span class="count">(14)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Dress</a><span class="count">(14)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Drink</a><span class="count">(14)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Fashion</a><span class="count">(11)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Food </a><span class="count">(13)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Men </a><span class="count">(7)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Short</a><span class="count">(24)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Women</a><span class="count">(9)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Food </a><span class="count">(13)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Men </a><span class="count">(7)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Short</a><span class="count">(24)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Women</a><span class="count">(9)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Clothings</a><span class="count">(29)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Dress</a><span class="count">(14)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Drink</a><span class="count">(2)</span></li>
                        <li><input name="product-categori" type="checkbox"><a href="#">Fashion</a><span class="count">(11)</span></li>
                    </ul>
                </form>
            </div>
        </div> -->
        <div class="shop-sidebar">
            <h4>Product Categories</h4>
            <div class="categori-checkbox">
                <ul class="list-wrap">
                    <c:forEach items="${allCategories}" var="category">
                        <li>
                            <div class="form-check">
                                <input class="category-filter" type="checkbox" name="category"
                                       value="${category.categoryId}" id="cat_${category.categoryId}"
                                       <c:if test="${selectedCategories.contains(category.categoryId)}">checked</c:if>>
                                <label class="form-check-label" for="cat_${category.categoryId}">
                                    ${category.name}
                                </label>
                                <span class="count">(${categoryProductCounts[category.categoryId]})</span>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <!--Product Category Widget End-->
        <!--Color Category Widget Start-->
        <!-- <div class="shop-sidebar">
    <h4>Color</h4>
    <div class="categori-checkbox">
        <form action="#">
            <ul>
                <li><input name="product-categori" type="checkbox"><a href="#">Gold</a><span class="count">(1)</span></li>
                <li><input name="product-categori" type="checkbox"><a href="#">Green</a><span class="count">(4)</span></li>
                <li><input name="product-categori" type="checkbox"><a href="#">White</a><span class="count">(5)</span></li>
            </ul>
        </form>
    </div>
</div> -->
        <!--Color Category Widget End-->
        <!--Price Filter Widget Start-->
        <div class="shop-sidebar">
            <h4>Filter by price</h4>
            <div class="price-filter">
                <div id="slider-range"></div>
                <div class="price-slider-amount">
                    <div class="label-input">
                        <label>Price range: </label>
                        <input type="text" id="amount" name="price" readonly placeholder="Price range" 
                               style="border:0; color:#80b435; font-weight:bold; width:200%; margin-bottom:100px;" />
                        <input type="hidden" id="min-price" value="${minPrice}" />
                        <input type="hidden" id="max-price" value="${maxPrice}" />
                        <input type="hidden" id="selected-min-price" value="${selectedMinPrice}" />
                        <input type="hidden" id="selected-max-price" value="${selectedMaxPrice}" />
                    </div>
                    <button type="button" onclick="handleFilterChange('price')" 
                            style="width:100%; margin-top:10px; background-color:#80b435; color:white; border:none; padding:8px 0; border-radius:4px;">
                        Apply Filter
                    </button>
                </div>
            </div>
        </div>
        <!--Price Filter Widget End-->
        <!--Recent Product Widget Start-->
        <div class="shop-sidebar">
            <h4>Top Rated Products</h4>
            <div class="rc-product">
                <ul>
                    <c:forEach items="${topRatedProducts}" var="product">
                        <li>
                            <div class="rc-product-thumb img-full">
                                <a href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">
                                    <img src="${pageContext.request.contextPath}/${product.image}"
                                        alt="${product.productName}">
                                </a>
                            </div>
                            <div class="rc-product-content">
                                <h6><a
                                        href="${pageContext.request.contextPath}/home?action=product-details&id=${product.productId}">${product.productName}</a>
                                </h6>
                                <div class="rc-product-review">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa fa-star"></i>
                                    </c:forEach>
                                </div>

                                <div class="rc-product-price">
                                    <span class="price">$${product.price}</span>
                                </div>
                            </div>
                        </li>
                    </c:forEach>
                </ul>
            </div>
        </div>
        <!--Recent Product Widget End-->
        <!--Banner Widget Start-->
        <div class="shop-sidebar">
            <div class="sidebar-banner single-banner">
                <div class="banner-img">
                    <a href="#"><img src="img/banner/shop-sidebar.jpg" alt=""></a>
                </div>
            </div>
        </div>
        <!--Banner Widget End-->
        <!--Product Tags Widget Start-->
        <!-- <div class="shop-sidebar">
    <h4>Product Tags</h4>
    <div class="product-tag">
        <ul>
            <li><a href="#">blouse</a></li>
            <li><a href="#">clothes</a></li>
            <li><a href="#">fashion</a></li>
            <li><a href="#">handbag</a></li>
            <li><a href="#">laptop</a></li>
        </ul>
    </div>
</div> -->
        <!--Product Tags Widget End-->

        <script>
            // Initialize category filter functionality when document is ready
            document.addEventListener('DOMContentLoaded', function() {
                // Add event listeners to all category checkboxes
                document.querySelectorAll('.category-filter').forEach(function(checkbox) {
                    checkbox.addEventListener('change', function() {
                        applyCategoryFilter();
                    });
                });
            });
            
            // Function to apply category filter
            function applyCategoryFilter() {
                // Get all checked category checkboxes
                const selectedCategories = Array.from(document.querySelectorAll('.category-filter:checked'))
                    .map(function(checkbox) {
                        return checkbox.value;
                    });
                
                // Get current URL parameters
                const urlParams = new URLSearchParams(window.location.search);
                
                // Update categories parameter
                if (selectedCategories.length > 0) {
                    urlParams.set('categories', selectedCategories.join(','));
                } else {
                    urlParams.delete('categories');
                }
                
                // Reset to page 1
                urlParams.delete('page');
                
                // Redirect to updated URL
                window.location.href = window.location.pathname + '?' + urlParams.toString();
            }
            
            // Function to handle filter changes (used by price filter)
            function handleFilterChange(filterType) {
                if (filterType === 'price') {
                    const minValue = $("#slider-range").slider("values", 0);
                    const maxValue = $("#slider-range").slider("values", 1);
                    
                    const urlParams = new URLSearchParams(window.location.search);
                    urlParams.set('minPrice', minValue);
                    urlParams.set('maxPrice', maxValue);
                    urlParams.delete('page'); // Reset to page 1
                    
                    window.location.href = window.location.pathname + '?' + urlParams.toString();
                }
            }

            let currentFilters = {
                categories: [],
                priceRange: {
                    min: ${ minPrice },
                max: ${ maxPrice },
                selectedMin: ${ selectedMinPrice != null ? selectedMinPrice : minPrice},
            selectedMax: ${ selectedMaxPrice != null ? selectedMaxPrice : maxPrice }
        },
            page: 1
    };

            function updateCategoryFilters() {
                const categoryCheckboxes = document.querySelectorAll('.category-filter:checked');
                currentFilters.categories = Array.from(categoryCheckboxes).map(cb => cb.value);
                console.log('Categories selected:', currentFilters.categories);
            }

            function updatePriceFilters() {
                const sliderValues = $("#slider-range").slider("values");
                currentFilters.priceRange.selectedMin = sliderValues[0];
                currentFilters.priceRange.selectedMax = sliderValues[1];
                console.log('Price range selected:', currentFilters.priceRange);
            }

            function applyFilters(page = 1) {
                currentFilters.page = page;
                const baseUrl = "${pageContext.request.contextPath}/home";
                const params = new URLSearchParams();

                // Thêm categories nếu có
                if (currentFilters.categories.length > 0) {
                    params.set('categories', currentFilters.categories.join(','));
                }

                // Thêm price range
                if (currentFilters.priceRange.selectedMin !== currentFilters.priceRange.min) {
                    params.set('minPrice', currentFilters.priceRange.selectedMin);
                }
                if (currentFilters.priceRange.selectedMax !== currentFilters.priceRange.max) {
                    params.set('maxPrice', currentFilters.priceRange.selectedMax);
                }

                // Thêm page
                params.set('page', currentFilters.page);

                // Giữ lại search keyword từ URL hiện tại
                const currentSearch = new URLSearchParams(window.location.search).get('search');
                if (currentSearch) {
                    params.set('search', currentSearch);
                }

                // Tạo URL và redirect
                const queryString = params.toString();
                let newUrl = baseUrl;
                if (queryString) {
                    newUrl += '?' + queryString;
                }
                window.location.href = newUrl;
            }

            // Initialize filters from URL on page load
            function initializeFilters() {
                const urlParams = new URLSearchParams(window.location.search);

                // Khởi tạo categories
                const categories = urlParams.get('categories');
                if (categories) {
                    currentFilters.categories = categories.split(',');
                    currentFilters.categories.forEach(id => {
                        const checkbox = document.querySelector(`#cat_${id}`);
                        if (checkbox)
                            checkbox.checked = true;
                    });
                }

                // Khởi tạo price range
                const minPrice = urlParams.get('minPrice');
                const maxPrice = urlParams.get('maxPrice');
                if (minPrice) {
                    currentFilters.priceRange.selectedMin = parseInt(minPrice);
                }
                if (maxPrice) {
                    currentFilters.priceRange.selectedMax = parseInt(maxPrice);
                }

                // Khởi tạo page
                const page = urlParams.get('page');
                currentFilters.page = page ? parseInt(page) : 1;

                // Khởi tạo price slider
                $(function() {
                    $("#slider-range").slider({
                        range: true,
                        min: ${minPrice != null ? minPrice : 0},
                        max: ${maxPrice != null ? maxPrice : 1000000},
                        values: [
                            ${selectedMinPrice != null ? selectedMinPrice : minPrice != null ? minPrice : 0}, 
                            ${selectedMaxPrice != null ? selectedMaxPrice : maxPrice != null ? maxPrice : 1000000}
                        ],
                        slide: function(event, ui) {
                            // Format as VND with thousand separators
                            const minPrice = formatVND(ui.values[0]);
                            const maxPrice = formatVND(ui.values[1]);
                            $("#amount").val(minPrice + " - " + maxPrice);
                        }
                    });
                    
                    // Initial formatting
                    const minPrice = formatVND($("#slider-range").slider("values", 0));
                    const maxPrice = formatVND($("#slider-range").slider("values", 1));
                    $("#amount").val(minPrice + " - " + maxPrice);
                });
            }

            // Function to format numbers as VND with thousand separators
            function formatVND(amount) {
                return amount.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".") + " VNĐ";
            }

            // Call initialization on page load
            document.addEventListener('DOMContentLoaded', initializeFilters);
        </script>