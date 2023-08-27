# 🚗 egl_garage // Garage / Impound Script for ESX Legacy 1.8.5+

This script provides a robust garage system for FiveM servers running on ESX Legacy 1.8.5+, allowing players to store, retrieve, and manage their vehicles effortlessly.

# 🌟 Features

    Vehicle Management: Players can store their vehicles in defined garages and retrieve them later.
    Localization: Supports multiple languages, including English and French. Easily expandable to add more languages.
    Intuitive User Interface: Uses RageUI to provide players with an intuitive user interface.
    Flexible Configuration: Numerous configuration settings to tailor the script according to the server's needs.

# 🛠 Installation

    Clone or download this GitHub repository.
    Place the script in your server's resources folder.
    Add start egl_garage to your server.cfg file.
    Import the garage.sql file into your database to set up the necessary tables.
    Configure the script according to your needs by modifying the config.lua file.

# 📦 Dependencies

Ensure you have the following dependencies installed and set up on your server:

    es_extended: This is the ESX (EssentialMode Extended) framework for FiveM.
    VehicleDeformation: A resource that handles vehicle deformations. Link here
    ox_inventory: An inventory system for FiveM, often used as an alternative or replacement for esx_inventoryhud.
    ox_fuel: A script for managing vehicle fuel.

# ⚙️ Configuration

The config.lua file contains several configuration parameters to customize the script to your server:

    General Settings:
        Default language (Config.lang).
        Used currency (Config.currency).
        Price to retrieve a vehicle from the impound (Config.impound_price).
    Interface Settings: Configuration of the user interface, including size, color, and other interface properties.
    Blips: Settings for the map icons (blips) for garages and impounds.
    Markers: Configuration of markers to interact with the garage, such as storing or retrieving a vehicle.
    Garages: List of available garages with their coordinates for storing and retrieving vehicles.

# 🤝 Contribution

If you'd like to contribute to this project, please create a pull request. Any help is welcome, whether it's adding new features or fixing bugs.

# 📄 License

This project is licensed under the MIT license. Please refer to the LICENCE file for more details.

# 📞 Support and Contact

If you encounter any issues or have questions, please create an issue on this GitHub repository or contact me on discord: 0xeagle1337.
