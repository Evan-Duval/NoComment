import { Component } from '@angular/core';
import { FormBuilder, FormGroup, Validators, ReactiveFormsModule } from '@angular/forms';
import { RouterLink } from '@angular/router';
import { AuthService } from '../../../services/auth.service';

@Component({
  selector: 'app-login',
  standalone: true,
  imports: [RouterLink, ReactiveFormsModule],
  templateUrl: './login.component.html',
  styleUrl: './login.component.css'
})
export class LoginComponent {
  loginForm: FormGroup;

  constructor(
      private formBuilder: FormBuilder, 
      private authService: AuthService
    ) {
      this.loginForm = this.formBuilder.group({
        email: ['', [Validators.required, Validators.email]],
        password: ['', Validators.required],
      });
    }
  
    onSubmit() {
      console.log('Formulaire soumis');
      console.log(this.loginForm.value);  
      if (this.loginForm.valid) {
        const { 
          email,
          password,
        } = this.loginForm.value;
        this.authService.login(
          email,
          password,
        ).subscribe({
          next: (response) => {
            console.log('Connexion réussie', response);
            localStorage.setItem('token', response.accessToken);
          },
          error: (error) => {
            console.error('Erreur de Connexion', error);
          }
        });
      }
    }
}