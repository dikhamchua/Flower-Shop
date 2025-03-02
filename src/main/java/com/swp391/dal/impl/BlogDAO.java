package com.swp391.dal.impl;

import com.swp391.dal.DBContext;
import com.swp391.dal.I_DAO;
import com.swp391.entity.Blog;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

public class BlogDAO extends DBContext implements I_DAO<Blog> {
    
    @Override
    public List<Blog> findAll() {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs ORDER BY created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting all blogs: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    @Override
    public boolean update(Blog blog) {
        String sql = "UPDATE blogs SET title = ?, content = ?, status = ?, updated_at = NOW() WHERE blog_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, blog.getTitle());
            statement.setString(2, blog.getContent());
            statement.setString(3, blog.getStatus());
            statement.setInt(4, blog.getId());
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating blog: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    @Override
    public boolean delete(Blog blog) {
        return deleteBlog(blog.getId());
    }
    
    @Override
    public int insert(Blog blog) {
        String sql = "INSERT INTO blogs (title, content, author_id, status, created_at, updated_at) VALUES (?, ?, ?, ?, NOW(), NOW())";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            
            statement.setString(1, blog.getTitle());
            statement.setString(2, blog.getContent());
            statement.setInt(3, blog.getAuthorId());
            statement.setString(4, blog.getStatus());
            
            int affectedRows = statement.executeUpdate();
            
            if (affectedRows == 0) {
                throw new SQLException("Creating blog failed, no rows affected.");
            }
            
            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating blog failed, no ID obtained.");
            }
        } catch (SQLException e) {
            System.out.println("Error adding blog: " + e.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }
    
    @Override
    public Blog getFromResultSet(ResultSet rs) throws SQLException {
        Blog blog = new Blog();
        blog.setId(rs.getInt("blog_id"));
        blog.setTitle(rs.getString("title"));
        blog.setContent(rs.getString("content"));
        blog.setAuthorId(rs.getInt("author_id"));
        blog.setStatus(rs.getString("status"));
        blog.setCreatedAt(rs.getTimestamp("created_at"));
        blog.setUpdatedAt(rs.getTimestamp("updated_at"));
        return blog;
    }
    
    public List<Blog> getBlogsByStatus(String status) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs WHERE status = ? ORDER BY created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, status);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting blogs by status: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    public List<Blog> getBlogsByAuthor(int authorId) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs WHERE author_id = ? ORDER BY created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, authorId);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error getting blogs by author: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    public Blog findById(int blogId) {
        String sql = "SELECT * FROM blogs WHERE blog_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, blogId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException e) {
            System.out.println("Error getting blog by ID: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return null;
    }
    
    public boolean deleteBlog(int blogId) {
        String sql = "DELETE FROM blogs WHERE blog_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, blogId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error deleting blog: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public boolean updateStatus(int blogId, String status) {
        String sql = "UPDATE blogs SET status = ?, updated_at = NOW() WHERE blog_id = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, status);
            statement.setInt(2, blogId);
            
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException e) {
            System.out.println("Error updating blog status: " + e.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }
    
    public boolean isBlogTitleExists(String title) {
        String sql = "SELECT COUNT(*) FROM blogs WHERE title = ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, title);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking blog title: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return false;
    }
    
    public boolean isBlogTitleExists(String title, int blogId) {
        String sql = "SELECT COUNT(*) FROM blogs WHERE title = ? AND blog_id != ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, title);
            statement.setInt(2, blogId);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1) > 0;
            }
        } catch (SQLException e) {
            System.out.println("Error checking blog title: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return false;
    }
    
    public List<Blog> findBlogsByTitle(String title) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs WHERE title LIKE ? ORDER BY created_at DESC";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setString(1, "%" + title + "%");
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error finding blogs by title: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    public List<Blog> findBlogsWithPagination(int page, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        String sql = "SELECT * FROM blogs ORDER BY created_at DESC LIMIT ? OFFSET ?";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            
            statement.setInt(1, pageSize);
            statement.setInt(2, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error finding blogs with pagination: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    public int getTotalBlogs() {
        String sql = "SELECT COUNT(*) FROM blogs";
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting blogs: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    /**
     * Find blogs with filtering and pagination
     * @param title Title search term (can be null)
     * @param status Status filter (can be null)
     * @param page Page number (1-based)
     * @param pageSize Number of items per page
     * @return List of blogs matching the criteria
     */
    public List<Blog> findBlogsWithFilter(String title, String status, int page, int pageSize) {
        List<Blog> blogs = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM blogs WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add title filter if provided
        if (title != null && !title.isEmpty()) {
            sqlBuilder.append(" AND title LIKE ?");
            params.add("%" + title + "%");
        }
        
        // Add status filter if provided
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }
        
        // Add ordering and pagination
        sqlBuilder.append(" ORDER BY created_at DESC LIMIT ? OFFSET ?");
        params.add(pageSize);
        params.add((page - 1) * pageSize);
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            
            while (resultSet.next()) {
                blogs.add(getFromResultSet(resultSet));
            }
        } catch (SQLException e) {
            System.out.println("Error finding blogs with filter: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return blogs;
    }
    
    /**
     * Count total blogs with filtering
     * @param title Title search term (can be null)
     * @param status Status filter (can be null)
     * @return Total number of blogs matching the criteria
     */
    public int countBlogsWithFilter(String title, String status) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM blogs WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        // Add title filter if provided
        if (title != null && !title.isEmpty()) {
            sqlBuilder.append(" AND title LIKE ?");
            params.add("%" + title + "%");
        }
        
        // Add status filter if provided
        if (status != null && !status.isEmpty()) {
            sqlBuilder.append(" AND status = ?");
            params.add(status);
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            // Set parameters
            for (int i = 0; i < params.size(); i++) {
                statement.setObject(i + 1, params.get(i));
            }
            
            resultSet = statement.executeQuery();
            
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException e) {
            System.out.println("Error counting blogs with filter: " + e.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }
    
    public static void main(String[] args) {
        BlogDAO blogDAO = new BlogDAO();
        
        // Test insert
        Blog newBlog = new Blog();
        newBlog.setTitle("Test Blog");
        newBlog.setContent("This is a test blog content");
        newBlog.setAuthorId(1); // Assuming author ID 1 exists
        newBlog.setStatus("published");
        
        int newId = blogDAO.insert(newBlog);
        
        if (newId > 0) {
            System.out.println("Blog inserted successfully! New ID: " + newId);
            
            // Test findById
            Blog found = blogDAO.findById(newId);
            if (found != null) {
                System.out.println("Found blog: " + found.getTitle());
                
                // Test update
                found.setTitle("Updated Test Blog");
                boolean updated = blogDAO.update(found);
                System.out.println("Blog updated: " + updated);
                
                // Test delete
                boolean deleted = blogDAO.delete(found);
                System.out.println("Blog deleted: " + deleted);
            }
        } else {
            System.out.println("Failed to insert blog.");
        }
        
        // Test findAll
        List<Blog> allBlogs = blogDAO.findAll();
        System.out.println("Total blogs: " + allBlogs.size());
    }
} 