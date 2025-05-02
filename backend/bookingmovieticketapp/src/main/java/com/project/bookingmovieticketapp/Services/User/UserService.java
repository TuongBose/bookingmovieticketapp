package com.project.bookingmovieticketapp.Services.User;

import com.project.bookingmovieticketapp.DTOs.UserDTO;
import com.project.bookingmovieticketapp.Models.User;
import com.project.bookingmovieticketapp.Repositories.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;

@RequiredArgsConstructor
@Service
public class UserService implements IUserService {
    private final UserRepository userRepository;

    @Override
    public User createUser(UserDTO userDTO) throws Exception {
        String phoneNumber = userDTO.getPhonenumber();
        if (userRepository.existsByphonenumber(phoneNumber))
            throw new RuntimeException("So dien thoai nay da ton tai");

        User newUser = User
                .builder()
                .name(userDTO.getName())
                .email(userDTO.getEmail())
                .password(userDTO.getPassword())
                .phonenumber(userDTO.getPhonenumber())
                .dateofbirth(userDTO.getDateofbirth())
                .isactive(true)
                .rolename(false)
                .build();
        return userRepository.save(newUser);
    }

    @Override
    public User login(String phoneNumber, String password) throws Exception {
        Optional<User> userOptional = userRepository.findByphonenumber(phoneNumber);
        if (userOptional.isEmpty())
            throw new RuntimeException("Sai so dien thoai hoac password");

        User existingUser = userOptional.get();
        if (!existingUser.getPassword().equals(password)) {
            throw new RuntimeException("Sai so dien thoai hoac password");
        }

        return existingUser;
    }

    @Override
    public List<User> getAllUserCustomer() {
        return userRepository.findByRolenameFalse();
    }

    @Override
    public List<User> getAllUserAdmin() {
        return userRepository.findByRolenameTrue();
    }
}
