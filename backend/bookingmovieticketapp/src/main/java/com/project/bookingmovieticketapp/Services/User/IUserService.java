package com.project.bookingmovieticketapp.Services.User;

import com.project.bookingmovieticketapp.DTOs.UserDTO;
import com.project.bookingmovieticketapp.Models.User;

public interface IUserService {
    User createUser(UserDTO userDTO) throws Exception;
    User login(String phoneNumber, String password) throws Exception;
}
