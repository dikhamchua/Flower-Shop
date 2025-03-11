package com.swp391.dal.impl;

import java.sql.*;
import java.util.List;
import java.util.ArrayList;
import com.swp391.entity.Slider;
import com.swp391.dal.I_DAO;
import com.swp391.dal.DBContext;

/**
 *
 * @author ADMIN
 */
public class SliderDAO extends DBContext implements I_DAO<Slider> {

    @Override
    public List<Slider> findAll() {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM sliders";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding all sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    @Override
    public boolean update(Slider slider) {
        String sql = "UPDATE sliders SET image_url = ?, link = ?, caption = ?, status = ? WHERE slider_id = ?";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setString(1, slider.getImageUrl());
            statement.setString(2, slider.getLink());
            statement.setString(3, slider.getCaption());
            statement.setByte(4, slider.getStatus());
            statement.setInt(5, slider.getSliderId());

            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating slider: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public boolean delete(Slider slider) {
        String sql = "DELETE FROM sliders WHERE slider_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, slider.getSliderId());
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error deleting slider: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    @Override
    public int insert(Slider slider) {
        String sql = "INSERT INTO sliders (image_url, link, caption, status) VALUES (?, ?, ?, ?)";

        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            statement.setString(1, slider.getImageUrl());
            statement.setString(2, slider.getLink());
            statement.setString(3, slider.getCaption());
            statement.setByte(4, slider.getStatus());

            int affectedRows = statement.executeUpdate();

            if (affectedRows == 0) {
                throw new SQLException("Creating slider failed, no rows affected.");
            }

            resultSet = statement.getGeneratedKeys();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            } else {
                throw new SQLException("Creating slider failed, no ID obtained.");
            }
        } catch (SQLException ex) {
            System.out.println("Error inserting slider: " + ex.getMessage());
            return -1;
        } finally {
            closeResources();
        }
    }

    @Override
    public Slider getFromResultSet(ResultSet rs) throws SQLException {
        Slider slider = new Slider();
        slider.setSliderId(rs.getInt("slider_id"));
        slider.setImageUrl(rs.getString("image_url"));
        slider.setLink(rs.getString("link"));
        slider.setCaption(rs.getString("caption"));
        slider.setStatus(rs.getByte("status"));
        slider.setCreatedAt(rs.getTimestamp("created_at"));
        slider.setUpdatedAt(rs.getTimestamp("updated_at"));
        return slider;
    }

    public Slider findById(int sliderId) {
        String sql = "SELECT * FROM sliders WHERE slider_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, sliderId);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return getFromResultSet(resultSet);
            }
        } catch (SQLException ex) {
            System.out.println("Error finding slider by ID: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return null;
    }

    public List<Slider> findActiveSliders() {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM sliders WHERE status = 1";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding active sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    public List<Slider> findSlidersWithPagination(int page, int pageSize) {
        List<Slider> sliders = new ArrayList<>();
        String sql = "SELECT * FROM sliders ORDER BY slider_id LIMIT ? OFFSET ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setInt(1, pageSize);
            statement.setInt(2, (page - 1) * pageSize);
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding sliders with pagination: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }

    public int getTotalSliders() {
        String sql = "SELECT COUNT(*) FROM sliders";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting sliders: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return 0;
    }

    public boolean updateStatus(int sliderId, byte status) {
        String sql = "UPDATE sliders SET status = ? WHERE slider_id = ?";
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sql);
            statement.setByte(1, status);
            statement.setInt(2, sliderId);
            int affectedRows = statement.executeUpdate();
            return affectedRows > 0;
        } catch (SQLException ex) {
            System.out.println("Error updating slider status: " + ex.getMessage());
            return false;
        } finally {
            closeResources();
        }
    }

    public List<Slider> findSlidersWithFilter(String caption, Byte status, int page, int pageSize) {
        List<Slider> sliders = new ArrayList<>();
        StringBuilder sqlBuilder = new StringBuilder("SELECT * FROM sliders WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        if (caption != null && !caption.trim().isEmpty()) {
            sqlBuilder.append(" AND caption LIKE ?");
            parameters.add("%" + caption + "%");
        }
        
        if (status != null) {
            sqlBuilder.append(" AND status = ?");
            parameters.add(status);
        }
        
        sqlBuilder.append(" ORDER BY slider_id LIMIT ? OFFSET ?");
        parameters.add(pageSize);
        parameters.add((page - 1) * pageSize);
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Byte) {
                    statement.setByte(i + 1, (Byte) param);
                } else if (param instanceof Integer) {
                    statement.setInt(i + 1, (Integer) param);
                }
            }
            
            resultSet = statement.executeQuery();
            while (resultSet.next()) {
                sliders.add(getFromResultSet(resultSet));
            }
        } catch (SQLException ex) {
            System.out.println("Error finding sliders with filter: " + ex.getMessage());
        } finally {
            closeResources();
        }
        return sliders;
    }
    
    public int countSlidersWithFilter(String caption, Byte status) {
        StringBuilder sqlBuilder = new StringBuilder("SELECT COUNT(*) FROM sliders WHERE 1=1");
        List<Object> parameters = new ArrayList<>();
        
        if (caption != null && !caption.trim().isEmpty()) {
            sqlBuilder.append(" AND caption LIKE ?");
            parameters.add("%" + caption + "%");
        }
        
        if (status != null) {
            sqlBuilder.append(" AND status = ?");
            parameters.add(status);
        }
        
        try {
            connection = getConnection();
            statement = connection.prepareStatement(sqlBuilder.toString());
            
            for (int i = 0; i < parameters.size(); i++) {
                Object param = parameters.get(i);
                if (param instanceof String) {
                    statement.setString(i + 1, (String) param);
                } else if (param instanceof Byte) {
                    statement.setByte(i + 1, (Byte) param);
                }
            }
            
            resultSet = statement.executeQuery();
            if (resultSet.next()) {
                return resultSet.getInt(1);
            }
        } catch (SQLException ex) {
            System.out.println("Error counting sliders with filter: " + ex.getMessage());
        } finally {
            closeResources();
        }
        
        return 0;
    }

    public static void main(String[] args) {
        SliderDAO sliderDAO = new SliderDAO();
        
        // Test insert
        Slider newSlider = new Slider();
        newSlider.setImageUrl("test-image.jpg");
        newSlider.setLink("https://example.com");
        newSlider.setCaption("Test Slider");
        newSlider.setStatus((byte) 1);
        
        int newId = sliderDAO.insert(newSlider);
        
        if (newId > 0) {
            System.out.println("Slider inserted successfully! New ID: " + newId);
            
            // Test findById
            Slider found = sliderDAO.findById(newId);
            if (found != null) {
                System.out.println("Found slider: " + found.getCaption());
                
                // Test update
                found.setCaption("Updated Test Slider");
                boolean updated = sliderDAO.update(found);
                System.out.println("Slider updated: " + updated);
                
                // Test delete
                boolean deleted = sliderDAO.delete(found);
                System.out.println("Slider deleted: " + deleted);
            }
        } else {
            System.out.println("Failed to insert slider.");
        }
        
        // Test findAll
        List<Slider> allSliders = sliderDAO.findAll();
        System.out.println("Total sliders: " + allSliders.size());
    }
} 