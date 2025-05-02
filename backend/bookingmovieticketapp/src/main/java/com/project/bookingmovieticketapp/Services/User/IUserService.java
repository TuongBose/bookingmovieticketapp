package com.project.bookingmovieticketapp.Services.User;

import com.project.bookingmovieticketapp.DTOs.UserDTO;
import com.project.bookingmovieticketapp.Models.User;

import java.util.List;

public interface IUserService {
    User createUser(UserDTO userDTO) throws Exception;
    User login(String phoneNumber, String password) throws Exception;
    List<User> getAllUserCustomer();
    List<User> getAllUserAdmin();
}
